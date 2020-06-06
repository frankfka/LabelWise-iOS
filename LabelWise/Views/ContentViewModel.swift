//
// Created by Frank Jia on 2020-06-05.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Resolver
import Combine

extension ContentView {
    class ViewModel: StateMachineViewModel<ViewModel.State, ViewModel.Action>, ObservableObject {
        // State machine
        enum State {
            case loading
            case noPermissions
            case onboarding
            case mainApp
        }
        enum Action {
            case loaded(didOnboard: Bool, hasCameraPermissions: Bool)
            case onboarded(grantedPermissions: Bool)
        }

        // Middleware
        override var middleware: [Middleware<Action>] {
            get {
                [
                    self.loggingMiddleware
                ]
            }
            set {
            }
        }

        // View-specific properties
        @Injected private var deviceService: DeviceService
        private var cameraPermissionsCancellable: AnyCancellable?

        // Initialization
        init() {
            super.init(state: .loading)
            // Check to see whether we have completed onboarding
            if deviceService.didCompleteOnboarding() {
                // Check for camera permission
                self.cameraPermissionsCancellable = deviceService.checkAndPromptForCameraPermission()
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(err) = completion {
                            AppLogging.error("Error checking for camera permission: \(err)")
                            self?.send(.loaded(didOnboard: true, hasCameraPermissions: false))
                        }
                    }, receiveValue: { [weak self] hasPermission in
                        self?.send(.loaded(didOnboard: true, hasCameraPermissions: true))
                    })
            } else {
                // Go to onboarding
                self.send(.loaded(didOnboard: false, hasCameraPermissions: false))
                self.cameraPermissionsCancellable = nil
            }
        }


        override func nextState(for action: Action) -> State? {
            switch state {
            case .loading:
                switch action {
                case .loaded(let didOnboard, let hasPermissions):
                    if didOnboard {
                        if hasPermissions {
                            return .mainApp
                        } else {
                            return .noPermissions
                        }
                    } else {
                        return .onboarding
                    }
                default:
                    return nil
                }
            case .onboarding:
                switch action {
                case .onboarded(let hasPermission):
                    if hasPermission {
                        return .mainApp
                    } else {
                        return .noPermissions
                    }
                default:
                    return nil
                }
            default:
                return nil
            }
        }

        override func enterState(_ state: State) {
            super.enterState(state)
            self.objectWillChange.send() // This allows views to reload whenever state is changed
        }

        // MARK: Actions
        func onOnboardingComplete() {
            // When onboarding is complete, note this in device defaults, then ask for permission
            deviceService.completedOnboarding()
            cameraPermissionsCancellable = deviceService.checkAndPromptForCameraPermission()
                .sink(receiveCompletion: { completion in
                    if case let .failure(err) = completion {
                        AppLogging.error("Error checking and prompting for camera permission: \(err)")
                        // Assume no permissions
                        self.send(.onboarded(grantedPermissions: false))
                    }
                }, receiveValue: { hasPermission in
                    self.send(.onboarded(grantedPermissions: hasPermission))
                })
        }

        // MARK: Middleware
        private var loggingMiddleware: Middleware<Action> {
            AppMiddleware.getLoggingMiddleware(state: self.state, getErr: { action in
                nil // No error actions yet
            })
        }
    }
}