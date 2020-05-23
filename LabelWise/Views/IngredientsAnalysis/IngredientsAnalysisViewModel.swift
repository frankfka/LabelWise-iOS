//
// Created by Frank Jia on 2020-05-23.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension IngredientsAnalysisRootView {
    class ViewModel: StateMachineViewModel<ViewModel.State, ViewModel.Action>, ObservableObject {
        // State machine
        enum State {
            case analyzing
            case analyzeError
            case displayResults
        }
        enum Action {
            case analyzed(result: AnalyzeIngredientsResponseDTO)
            case analyzeError(err: AppError)
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
        @Published var analysisResult: AnalyzeIngredientsResponseDTO? = nil
        private let onReturnToLabelScannerCallback: VoidCallback?
        private var analysisCancellable: AnyCancellable?

        // Initialization
        init(resultPublisher: ServicePublisher<AnalyzeIngredientsResponseDTO>? = nil,
             onReturnToLabelScannerCallback: VoidCallback? = nil) {
            self.onReturnToLabelScannerCallback = onReturnToLabelScannerCallback
            super.init(state: .analyzing)
            if resultPublisher == nil {
                AppLogging.warn("Initializing IngredientsAnalysisRootViewModel with null resultPublisher")
            }
            // Run the network call on init
            self.analysisCancellable = resultPublisher?.sink(receiveCompletion: { [weak self] completion in
                if let err = completion.getError() {
                    self?.send(.analyzeError(err: err))
                }
            }, receiveValue: { [weak self] response in
                self?.send(.analyzed(result: response))
            })
        }

        override func nextState(for action: Action) -> State? {
            switch state {
            case .analyzing:
                switch action {
                case let .analyzed(result):
                    self.analysisResult = result
                    return .displayResults
                case .analyzeError:
                    return .analyzeError
                }
            case .analyzeError:
                return nil // Terminal state
            case .displayResults:
                return nil // Terminal state
            }
        }

        override func enterState(_ state: State) {
            super.enterState(state)
            self.objectWillChange.send() // This allows views to reload whenever state is changed
        }

        // MARK: Actions
        func returnToLabelScanner() {
            self.onReturnToLabelScannerCallback?()
        }

        // MARK: Middleware
        private var loggingMiddleware: Middleware<Action> {
            AppMiddleware.getLoggingMiddleware(state: self.state, getErr: { action in
                switch action {
                case let .analyzeError(err):
                    return err
                default:
                    return nil
                }
            })
        }
    }
}