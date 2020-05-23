//
// Created by Frank Jia on 2020-05-20.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct PreviewIngredientsModels {
    // MARK: Responses
    static let ResponseWithAllTypes = AnalyzeIngredientsResponseDTO(
        parsedIngredients: ["dextrose", "salt", "mango"],
        analyzedIngredients: [AnalyzedIngredientDextrose]
    )

    // MARK: Analyzed Ingredient
    static let AnalyzedIngredientNoInsights = AnalyzedIngredientDTO(name: "maltodextrin", insights: [], additiveInfo: nil)
    static let AnalyzedIngredientMultipleInsights = AnalyzedIngredientDTO(name: "some ingredient", insights: [InsightAddedSugar, InsightScogs4], additiveInfo: nil)
    static let AnalyzedIngredientDextrose = AnalyzedIngredientDTO(name: "dextrose", insights: [InsightAddedSugar], additiveInfo: nil)

    // MARK: Insights
    static let InsightAddedSugar = IngredientInsightDTO(code: .addedSugar, type: .cautionWarn)
    static let InsightScogs4 = IngredientInsightDTO(code: .scogs4, type: .cautionWarn)
}