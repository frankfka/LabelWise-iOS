//
// Created by Frank Jia on 2020-05-04.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct PreviewNutritionModels {
    // Parsed nutrition
    static let FullyParsedNutritionDto: AnalyzeNutritionResponseDTO.ParsedNutrition =
            AnalyzeNutritionResponseDTO.ParsedNutrition(
                    calories: 210,
                    carbohydrates: 4,
                    sugar: 1,
                    fiber: 2,
                    protein: 10,
                    fat: 2,
                    satFat: 1,
                    cholesterol: 400,
                    sodium: 300
            )
}