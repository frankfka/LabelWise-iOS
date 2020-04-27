//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    // TODO
}

// MARK: Analyze nutrition
struct AnalyzeNutritionRequestDTO: Codable {
    let type: AnalyzeType
    let base64Image: String

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case base64Image = "b64_img"
    }
}

struct AnalyzeNutritionResponseDTO: Codable {

    struct ParsedNutrition: Codable {
        let calories: Double?
        let carbohydrates: Double?
        let sugar: Double?
        let fiber: Double?
        let protein: Double?
        let fat: Double?
        let satFat: Double?
        let cholesterol: Double?
        let sodium: Double?
    }

    let parsedNutrition: ParsedNutrition
    let warnings: [NutritionWarningDTO]

    enum CodingKeys: String, CodingKey {
        case parsedNutrition = "parsed_nutrition"
        case warnings = "warnings"
    }
}