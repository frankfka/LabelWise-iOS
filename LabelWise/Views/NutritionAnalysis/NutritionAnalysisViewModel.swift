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
    class ViewModel: StateMachineViewModel<ViewModel.State, ViewModel.Action>, ObservableObject {
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
                    if result.status == .complete || result.status == .incomplete {
                        self.analysisResult = result
                        return .displayResults
                    } else if result.status == .unknown {
                        return .analyzeError
                    } else {
                        return .insufficientInfo
                    }
                case .analyzeError:
                    return .analyzeError
                }
            case .analyzeError:
                return nil // Terminal state
            case .displayResults:
                return nil // Terminal state
            case .insufficientInfo:
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
// MARK: Additional helper models
struct Nutrition {
    static let CaloriesPerGramCarbs: Double = 4
    static let CaloriesPerGramProtein: Double = 4
    static let CaloriesPerGramFat: Double = 9

    private let dto: AnalyzeNutritionResponseDTO.ParsedNutrition
    private let dailyValues: DailyNutritionValues
    var calories: Double? {
        dto.calories
    }
    var caloriesDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: calories, dailyValue: dailyValues.calories)
    }
    var carbohydrates: Double? {
        dto.carbohydrates
    }
    var carbohydratesPercent: Double? {
        NutritionViewUtils.getPercentage(amount: (carbohydrates ?? 0) * Nutrition.CaloriesPerGramCarbs, total: calories)
    }
    var carbohydratesDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: carbohydrates, dailyValue: dailyValues.carbohydrates)
    }
    var sugar: Double? {
        dto.sugar
    }
    var sugarDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: sugar, dailyValue: dailyValues.sugar)
    }
    var fiber: Double? {
        dto.fiber
    }
    var fiberDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: fiber, dailyValue: dailyValues.fiber)
    }
    var protein: Double? {
        dto.protein
    }
    var proteinPercent: Double? {
        NutritionViewUtils.getPercentage(amount: (protein ?? 0) * Nutrition.CaloriesPerGramProtein, total: calories)
    }
    var proteinDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: protein, dailyValue: dailyValues.protein)
    }
    var fat: Double? {
        dto.fat
    }
    var fatPercent: Double? {
        NutritionViewUtils.getPercentage(amount: (fat ?? 0) * Nutrition.CaloriesPerGramFat, total: calories)
    }
    var fatDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: fat, dailyValue: dailyValues.fat)
    }
    var satFat: Double? {
        dto.satFat
    }
    var satFatDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: satFat, dailyValue: dailyValues.satFat)
    }
    var cholesterol: Double? {
        dto.cholesterol
    }
    var cholesterolDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: cholesterol, dailyValue: dailyValues.cholesterol)
    }
    var sodium: Double? {
        dto.sodium
    }
    var sodiumDVPercent: Double? {
        NutritionViewUtils.getDailyValuePercentage(amount: sodium, dailyValue: dailyValues.sodium)
    }

    init(dto: AnalyzeNutritionResponseDTO.ParsedNutrition, dailyValues: DailyNutritionValues) {
        self.dto = dto
        self.dailyValues = dailyValues
    }
}
enum NutrientAmountUnit {
    case none
    case grams
    case milligrams

    var abbreviatedString: String {
        switch self {
        case .none:
            return ""
        case .grams:
            return "g"
        case .milligrams:
            return "mg"
        }
    }
}
