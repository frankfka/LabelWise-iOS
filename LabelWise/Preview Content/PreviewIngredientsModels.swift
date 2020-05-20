//
// Created by Frank Jia on 2020-05-20.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct PreviewIngredientsModels {
    // MARK: Responses
    static let ResponseWithAllTypes: AnalyzeIngredientsResponseDTO = AnalyzeIngredientsResponseDTO(
        parsedIngredients: ["dextrose", "salt", "mango"],
        analyzedIngredients: [AnalyzedIngredientDextrose]
    )

    // MARK: Analyzed Ingredient
    static let AnalyzedIngredientDextrose: AnalyzedIngredientDTO = AnalyzedIngredientDTO(name: "dextrose", insights: [InsightAddedSugar], additiveInfo: nil)

    // MARK: Insights
    static let InsightAddedSugar: IngredientInsightDTO = IngredientInsightDTO(code: .addedSugar, type: .cautionWarn)
}