//
// Created by Frank Jia on 2020-04-25.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

// MARK: Request
struct AnalyzeNutritionRequestDTO {
    let type: AnalyzeType
    let base64Image: String
}
extension AnalyzeNutritionRequestDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case base64Image = "b64_img"
    }
}

// MARK: Response
struct AnalyzeNutritionResponseDTO {
    enum Status: String, Codable {
        case complete = "COMPLETE"
        case incomplete = "INCOMPLETE"
        case insufficient = "INSUFFICIENT"
        case unknown = "UNKNOWN"
    }
    struct ParsedNutrition {
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
    let status: Status
    let parsedNutrition: ParsedNutrition
    let insights: [NutritionInsightDTO]
}
extension AnalyzeNutritionResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case parsedNutrition = "parsed_nutrition"
        case insights = "insights"
    }
}
extension AnalyzeNutritionResponseDTO.ParsedNutrition: Codable {
    enum CodingKeys: String, CodingKey {
        case calories = "calories"
        case carbohydrates = "carbohydrates"
        case sugar = "sugar"
        case fiber = "fiber"
        case protein = "protein"
        case fat = "fat"
        case satFat = "saturated_fat"
        case cholesterol = "cholesterol"
        case sodium = "sodium"
    }
}

struct NutritionInsightDTO {
    enum InsightType: Int, Codable {
        case none = 0
        case positive = 1
        case cautionWarn = -1
        case cautionSevere = -2
    }
    enum Code: String, Codable {
        // Positive
        case lowSodium = "LOW_SODIUM"
        case lowSugar = "LOW_SUGAR"
        case highFiber = "HIGH_FIBER"
        case highProtein = "HIGH_PROTEIN"
        // Warnings
        case highSodium = "HIGH_SODIUM"
        case highSugar = "HIGH_SUGAR"
        case lowFiber = "LOW_FIBER"
        case highSatFat = "HIGH_SAT_FAT"
        case highCholesterol = "HIGH_CHOLESTEROL"
        case unknown = "UNKNOWN"
    }

    let code: Code
    let type: InsightType
}
extension NutritionInsightDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case type = "type"
    }
}
// MARK: Extensions for enum decodables - default to an unknown value so we can filter it out
extension NutritionInsightDTO.InsightType {
    public init(from decoder: Decoder) throws {
        self = try NutritionInsightDTO.InsightType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .none
    }
}
extension NutritionInsightDTO.Code {
    public init(from decoder: Decoder) throws {
        self = try NutritionInsightDTO.Code(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
extension AnalyzeNutritionResponseDTO.Status {
    public init(from decoder: Decoder) throws {
        self = try AnalyzeNutritionResponseDTO.Status(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
