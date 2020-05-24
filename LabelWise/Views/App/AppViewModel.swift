//
// Created by Frank Jia on 2020-05-04.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Resolver

// Passed up from label scanner
typealias LabelScannedCallback = (LabelImage, AnalyzeType, Bool) -> () // TODO: 3rd argument is temp for testing

// MARK: Root view model
extension AppView {
    class ViewModel: StateMachineViewModel<ViewModel.State, ViewModel.Action>, ObservableObject {
        // State machine
        enum State {
            case scanLabel
            case analyzeNutrition
            case analyzeIngredients
        }
        enum Action {
            case analyzeNutrition(image: LabelImage, isTest: Bool)
            case analyzeIngredients(image: LabelImage, isTest: Bool)
            case returnToScanner
        }

        // Middleware
        override var middleware: [Middleware<Action>] {
            get {
                [
                    self.loggingMiddleware,
                    self.analyzeIngredientsMiddleware,
                    self.analyzeNutritionMiddleware
                ]
            }
            set {
            }
        }

        // View-specific properties
        @Injected private var labelAnalysisService: LabelAnalysisService
        private(set) var analyzeNutritionPublisher: ServicePublisher<AnalyzeNutritionResponseDTO>? = nil
        private(set) var analyzeIngredientsPublisher: ServicePublisher<AnalyzeIngredientsResponseDTO>? = nil

        // Initialization
        init() {
            super.init(state: .scanLabel)
        }


        override func nextState(for action: Action) -> State? {
            switch state {
            case .scanLabel:
                switch action {
                case .analyzeIngredients:
                    // Populating state is done in middleware
                    return .analyzeIngredients
                case .analyzeNutrition:
                    // Populating state is done in middleware
                    return .analyzeNutrition
                default:
                    return nil
                }
            case .analyzeNutrition:
                switch action {
                case .returnToScanner:
                    return .scanLabel
                default:
                    return nil
                }
            case .analyzeIngredients:
                switch action {
                case .returnToScanner:
                    return .scanLabel
                default:
                    return nil
                }
            }
        }

        override func enterState(_ state: State) {
            super.enterState(state)
            self.objectWillChange.send() // This allows views to reload whenever state is changed
            if case .scanLabel = state {
                // Entering scanning label, reset publishers
            }
        }

        // MARK: Actions

        // Callback from LabelScannerView to kick off analysis
        func onLabelScanned(image: LabelImage, type: AnalyzeType, isTest: Bool) {
            switch type {
            case .ingredients:
                self.send(.analyzeIngredients(image: image, isTest: isTest))
            case .nutrition:
                self.send(.analyzeNutrition(image: image, isTest: isTest))
            }
        }

        // Callback from analysis views to return to label scanning
        func onReturnToLabelScannerTapped() {
            self.send(.returnToScanner)
        }

        // MARK: Middleware
        private var loggingMiddleware: Middleware<Action> {
            AppMiddleware.getLoggingMiddleware(state: self.state, getErr: { action in
                nil // No error actions yet
            })
        }
        // Middleware to analyze nutrition/ingredients
        private func analyzeNutritionMiddleware(_ action: Action) {
            guard case let .analyzeNutrition(image, isTest) = action else {
                return
            }
            if isTest {
                let parsedNutrition = PreviewNutritionModels.FullyParsedNutritionDto
                let insights = PreviewNutritionModels.MultipleInsightsPerType
                let response = AnalyzeNutritionResponseDTO(status: .complete, parsedNutrition: parsedNutrition, insights: insights)
                self.analyzeNutritionPublisher = MockAnalysisService.getServicePublisher(response: response)
            } else {
                self.analyzeNutritionPublisher = labelAnalysisService.analyzeNutrition(base64Image: image.compressedB64String)
            }
        }
        private func analyzeIngredientsMiddleware(_ action: Action) {
            guard case let .analyzeIngredients(image, isTest) = action else {
                return
            }
            if isTest {
                self.analyzeIngredientsPublisher = MockAnalysisService.getServicePublisher(response: PreviewIngredientsModels.ResponseWithAllTypes)
            } else {
                self.analyzeIngredientsPublisher = labelAnalysisService.analyzeIngredients(base64Image: image.compressedB64String)
            }
        }
    }
}