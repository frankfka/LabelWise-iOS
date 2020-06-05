import SwiftUI
import AVFoundation
import Resolver
import Combine

struct ContentView: View {

    @ObservedObject private var viewModel = ViewModel()

    @ViewBuilder
    var body: some View {
        if viewModel.state == .loading {
            Text("Loading")
        } else if viewModel.state == .noPermissions {
            Text("No permissions")
        } else if viewModel.state == .onboarding {
            Text("Onboarding")
        } else if viewModel.state == .mainApp {
            AppView()
        } else {
            Text("Invalid State")
        }
    }
}

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
        private var initCancellable: AnyCancellable?

        // Initialization
        init() {
            super.init(state: .loading)
            if deviceService.didCompleteOnboarding() {
                self.initCancellable = deviceService.checkAndPromptForCameraPermission()
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(err) = completion {
                            AppLogging.error("Error checking for camera permission: \(err)")
                            self?.send(.loaded(didOnboard: true, hasCameraPermissions: false))
                        }
                    }, receiveValue: { [weak self] hasPermission in
                        self?.send(.loaded(didOnboard: true, hasCameraPermissions: true))
                    })
            } else {
                self.send(.loaded(didOnboard: false, hasCameraPermissions: false))
                self.initCancellable = nil
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

        // MARK: Middleware
        private var loggingMiddleware: Middleware<Action> {
            AppMiddleware.getLoggingMiddleware(state: self.state, getErr: { action in
                nil // No error actions yet
            })
        }
    }
}

// Hosting controller for content view that has dynamic status bar style
class ContentHostingController: UIHostingController<ContentView> {
    private var currentStatusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentStatusBarStyle
    }
    func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        self.currentStatusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
