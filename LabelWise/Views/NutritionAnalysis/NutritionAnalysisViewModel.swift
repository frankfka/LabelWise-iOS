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
    class ViewModel: ObservableObject {
        // View properties
        @Published var viewState: ViewState = .analyzing
        @Published var analysisResult: AnalyzeNutritionResponseDTO? = nil

        // Callbacks
        let onReturnToLabelScannerCallback: VoidCallback?

        // Cancellables
        private var analysisCancellable: AnyCancellable?

        // Cancel any in-flight actions
        deinit {
            AppLogging.debug("Deinit NutritionAnalysisViewModel")
            analysisCancellable?.cancel()
        }

        // Technically, the publisher is non-nullable but this will just hang in a cancellable loading state
        init(resultPublisher: ServicePublisher<AnalyzeNutritionResponseDTO>? = nil,
             onReturnToLabelScannerCallback: VoidCallback? = nil) {
            self.onReturnToLabelScannerCallback = onReturnToLabelScannerCallback
            if resultPublisher == nil {
                AppLogging.error("Initializing NutritionAnalysisRootViewModel with null resultPublisher")
            }
            self.analysisCancellable = resultPublisher?.sink(receiveCompletion: { [weak self] completion in
                if let err = completion.getError() {
                    AppLogging.error("Error analyzing nutrition: \(String(describing: err))")
                    self?.viewState = .error
                }
            }, receiveValue: { [weak self] response in
                AppLogging.debug("Success analyzing nutrition. Parsed \(response.parsedNutrition.calories ?? 0) calories")
                self?.viewState = .displayResults
                self?.analysisResult = response
            })
        }
    }
}

// MARK: Additional models for vm
extension NutritionAnalysisRootView.ViewModel {
    // State of the analysis view
    enum ViewState {
        case analyzing
        case error
        case displayResults
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
        if let carbsGrams = carbsGrams, let calories = calories, calories > 0 {
            return (carbsGrams * Macronutrients.CaloriesPerGramCarbs / calories).toPercent()
        }
        return nil
    }
    var carbsDailyValuePercentage: Double? {
        if let carbsGrams = carbsGrams, dailyValues.carbohydrates > 0 {
            return (carbsGrams / dailyValues.carbohydrates).toPercent()
        }
        return nil
    }
    let proteinGrams: Double?
    var proteinPercentage: Double? {
        if let proteinGrams = proteinGrams, let calories = calories, calories > 0 {
            return (proteinGrams * Macronutrients.CaloriesPerGramProtein / calories).toPercent()
        }
        return nil
    }
    var proteinDailyValuePercentage: Double? {
        if let proteinGrams = proteinGrams, dailyValues.protein > 0 {
            return (proteinGrams / dailyValues.protein).toPercent()
        }
        return nil
    }
    let fatsGrams: Double?
    var fatsPercentage: Double? {
        if let fatsGrams = fatsGrams, let calories = calories, calories > 0 {
            return (fatsGrams * Macronutrients.CaloriesPerGramFat / calories).toPercent()
        }
        return nil
    }
    var fatsDailyValuePercentage: Double? {
        if let fatsGrams = fatsGrams, dailyValues.fat > 0 {
            return (fatsGrams / dailyValues.fat).toPercent()
        }
        return nil
    }

    init(nutritionDto: AnalyzeNutritionResponseDTO.ParsedNutrition, dailyValues: DailyNutritionValues) {
        self.dailyValues = dailyValues
        self.calories = nutritionDto.calories
        self.carbsGrams = nutritionDto.carbohydrates
        self.proteinGrams = nutritionDto.protein
        self.fatsGrams = nutritionDto.fat
    }
}
