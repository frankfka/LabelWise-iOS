//
// Created by Frank Jia on 2020-05-04.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct PreviewNutritionModels {
    // MARK: Parsed Nutrition
    // Fully parsed
    static let FullyParsedNutritionDto: AnalyzeNutritionResponseDTO.ParsedNutrition =
            AnalyzeNutritionResponseDTO.ParsedNutrition(
                    calories: 210,
                    carbohydrates: 35,
                    sugar: 7,
                    fiber: 6,
                    protein: 9,
                    fat: 5,
                    satFat: 2,
                    cholesterol: 15,
                    sodium: 240
            )
    static let FullyParsedMacronutrients: Macronutrients = Macronutrients(
            nutritionDto: FullyParsedNutritionDto,
            dailyValues: DailyNutritionValues()
    )
    // Improperly parsed

    // Partially parsed
    static let PartiallyParsedNutritionDto: AnalyzeNutritionResponseDTO.ParsedNutrition =
            AnalyzeNutritionResponseDTO.ParsedNutrition(
                    calories: 210,
                    carbohydrates: 35,
                    sugar: nil,
                    fiber: 6,
                    protein: nil,
                    fat: 5,
                    satFat: nil,
                    cholesterol: 15,
                    sodium: nil
            )
    static let PartiallyParsedMacronutrients: Macronutrients = Macronutrients(
            nutritionDto: PartiallyParsedNutritionDto,
            dailyValues: DailyNutritionValues()
    )
    // Nothing parsed
    static let NoneParsedNutritionDto: AnalyzeNutritionResponseDTO.ParsedNutrition =
            AnalyzeNutritionResponseDTO.ParsedNutrition(
                    calories: nil,
                    carbohydrates: nil,
                    sugar: nil,
                    fiber: nil,
                    protein: nil,
                    fat: nil,
                    satFat: nil,
                    cholesterol: nil,
                    sodium: nil
            )
    static let NoneParsedMacronutrients: Macronutrients = Macronutrients(
            nutritionDto: NoneParsedNutritionDto,
            dailyValues: DailyNutritionValues()
    )

    // MARK: Insights
    static let MultipleInsightsPerType: [NutritionInsightDTO] = [
        NutritionInsightDTO(code: .lowSugar, type: .positive),
        NutritionInsightDTO(code: .highFiber, type: .positive),
        NutritionInsightDTO(code: .highSatFat, type: .cautionWarn),
        NutritionInsightDTO(code: .highCholesterol, type: .cautionSevere),
        NutritionInsightDTO(code: .highSodium, type: .cautionSevere)
    ]
}