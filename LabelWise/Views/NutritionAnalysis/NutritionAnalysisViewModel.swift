//
//  NutritionAnalysisViewModel.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension NutritionAnalysisRootView {
    class ViewModel: StateMachineViewModel<ViewModel.State, ViewModel.Action> {
        // State machine
        enum State {
            case analyzing
            case analyzeError
            case displayResults
            case insufficientInfo
        }
        enum Action {
            case analyzed(result: AnalyzeNutritionResponseDTO)
            case analyzeError(err: AppError)
            case returnToScanner
        }

        // Middleware
        override var middleware: [Middleware<Action>] {
            get {
                [
                    self.loggingMiddleware,
                    self.analyzeSuccessMiddleware,
                    self.returnToScannerMiddleware
                ]
            }
            set {}
        }

        // View-specific properties
        @Published var analysisResult: AnalyzeNutritionResponseDTO? = nil
        private let onReturnToLabelScannerCallback: VoidCallback?
        private var analysisCancellable: AnyCancellable?

        // Initialization
        init(resultPublisher: ServicePublisher<AnalyzeNutritionResponseDTO>? = nil,
             onReturnToLabelScannerCallback: VoidCallback? = nil) {
            self.onReturnToLabelScannerCallback = onReturnToLabelScannerCallback
            super.init(state: .analyzing)
            if resultPublisher == nil {
                AppLogging.warn("Initializing NutritionAnalysisRootViewModel with null resultPublisher")
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
                    // Display results if we have complete parsing or some info parsed
                    return (result.status == .complete || result.status == .incomplete) ? .displayResults :
                            // Either insufficient or some weird error from API where we don't know the status
                            (result.status == .unknown) ? .analyzeError : .insufficientInfo
                case .analyzeError:
                    return .analyzeError
                case .returnToScanner:
                    return nil
                }
            case .analyzeError:
                return nil // Terminal state
            case .displayResults:
                return nil // Terminal state
            case .insufficientInfo:
                return nil // Terminal state
            }
        }

        // MARK: Middleware
        private func analyzeSuccessMiddleware(_ action: Action) {
            if case let .analyzed(result) = action {
                // Populate required property
                self.analysisResult = result
            }
        }
        private func returnToScannerMiddleware(_ action: Action) {
            if case .returnToScanner = action {
                self.onReturnToLabelScannerCallback?()
            }
        }
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
// MARK: Additional models for vm
extension NutritionAnalysisRootView.ViewModel {
    // State of the analysis view
    enum ViewState {
        case analyzing
        case analyzeError
        case displayResults
        case insufficientInfo
    }
}

// MARK: Additional helper models
struct Macronutrients {
    static let CaloriesPerGramCarbs: Double = 4
    static let CaloriesPerGramProtein: Double = 4
    static let CaloriesPerGramFat: Double = 9

    let dailyValues: DailyNutritionValues
    let calories: Double?
    let carbsGrams: Double?
    var carbsPercentage: Double? {
        NutritionViewUtils.getPercentage(amount: (carbsGrams ?? 0) * Macronutrients.CaloriesPerGramCarbs, total: calories)
    }
    var carbsDailyValuePercentage: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: carbsGrams, dailyValue: dailyValues.carbohydrates)
    }
    let proteinGrams: Double?
    var proteinPercentage: Double? {
        NutritionViewUtils.getPercentage(amount: (proteinGrams ?? 0) * Macronutrients.CaloriesPerGramProtein, total: calories)
    }
    var proteinDailyValuePercentage: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: proteinGrams, dailyValue: dailyValues.protein)
    }
    let fatsGrams: Double?
    var fatsPercentage: Double? {
        NutritionViewUtils.getPercentage(amount: (fatsGrams ?? 0) * Macronutrients.CaloriesPerGramFat, total: calories)
    }
    var fatsDailyValuePercentage: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: fatsGrams, dailyValue: dailyValues.fat)
    }

    init(nutritionDto: AnalyzeNutritionResponseDTO.ParsedNutrition, dailyValues: DailyNutritionValues) {
        self.dailyValues = dailyValues
        self.calories = nutritionDto.calories
        self.carbsGrams = nutritionDto.carbohydrates
        self.proteinGrams = nutritionDto.protein
        self.fatsGrams = nutritionDto.fat
    }
}
enum NutrientAmountUnit {
    case grams
    case milligrams

    var abbreviatedString: String {
        switch self {
        case .grams:
            return "g"
        case .milligrams:
            return "mg"
        }
    }
}
