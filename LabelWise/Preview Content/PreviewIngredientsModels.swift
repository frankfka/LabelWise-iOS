//
// Created by Frank Jia on 2020-05-20.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct PreviewIngredientsModels {
    // MARK: Responses
    static let ResponseWithAllTypes = AnalyzeIngredientsResponseDTO(
        status: .success,
        parsedIngredients: MultipleParsedIngredients,
        analyzedIngredients: [AnalyzedIngredientDextrose, AnalyzedIngredientMultipleInsights, AnalyzedIngredientNoInsights]
    )
    static let ResponseWithNoAnalyzedIngredients = AnalyzeIngredientsResponseDTO(
        status: .success,
        parsedIngredients: MultipleParsedIngredients,
        analyzedIngredients: []
    )
    static let ResponseWithNoParsedIngredients = AnalyzeIngredientsResponseDTO(
        status: .nonParsed,
        parsedIngredients: [],
        analyzedIngredients: []
    )

    // MARK: All Parsed Ingredients
    static let MultipleParsedIngredients = ["dextrose", "salt", "mango"]

    // MARK: Analyzed Ingredient
    static let AnalyzedIngredientNoInsights = AnalyzedIngredientDTO(name: "maltodextrin", insights: [], additiveInfo: nil)
    static let AnalyzedIngredientMultipleInsights = AnalyzedIngredientDTO(name: "some ingredient", insights: [InsightAddedSugar, InsightScogs4], additiveInfo: nil)
    static let AnalyzedIngredientDextrose = AnalyzedIngredientDTO(name: "dextrose", insights: [InsightAddedSugar], additiveInfo: nil)

    // MARK: Insights
    static let InsightAddedSugar = IngredientInsightDTO(code: .addedSugar, type: .cautionWarning)
    static let InsightScogs4 = IngredientInsightDTO(code: .scogs4, type: .cautionWarning)
}
