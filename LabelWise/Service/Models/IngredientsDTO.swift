//
// Created by Frank Jia on 2020-05-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

// Root response object
struct AnalyzeIngredientsResponseDTO {
    enum Status: String, Codable {
        case success = "SUCCESS"
        case nonParsed = "NON_PARSED"
        case unknown = "UNKNOWN"
    }
    let status: Status
    let parsedIngredients: [String] // Master list of all ingredients, even if we don't have data to analyze it
    let analyzedIngredients: [AnalyzedIngredientDTO]
}
extension AnalyzeIngredientsResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case status = "STATUS"
        case parsedIngredients = "parsed_ingredients"
        case analyzedIngredients = "analyzed_ingredients"
    }
}

// Analyzed ingredient object
struct AnalyzedIngredientDTO {
    let name: String
    let insights: [IngredientInsightDTO]
    let additiveInfo: AdditiveInfoDTO?
}
extension AnalyzedIngredientDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case insights = "insights"
        case additiveInfo = "additive_info"
    }
}

// Warnings for a particular ingredient
struct IngredientInsightDTO {
    // TODO: Make the insight type comparable, so we can sort them without too much hassle in the viewmodels (same for nutrition)
    enum InsightType: Int, Codable {
        case none = 0
        case positive = 1
        case cautionWarning = -1
        case severeWarning = -2
    }
    enum Code: String, Codable {
        // Positive
        case scogs1 = "SCOGS_1"
        case scogs2 = "SCOGS_2"
        // Warnings
        case addedSugar = "ADDED_SUGAR"
        case notGras = "NOT_GRAS"
        case scogs3 = "SCOGS_3"
        case scogs4 = "SCOGS_4"
        case scogs5 = "SCOGS_5"
        case unknown = "UNKNOWN"
    }
    let code: Code
    let type: InsightType
}
extension IngredientInsightDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case type = "type"
    }
}

// Optional info, if the ingredient is an additive
struct AdditiveInfoDTO {
    let names: [String]
    let casId: String
    let femaNumber: String
    let technicalEffects: [String]
    let scogsConclusion: Int? // Make this an enum when backend formally supports it
}
extension AdditiveInfoDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case names = "names"
        case casId = "cas_id"
        case femaNumber = "fema_num"
        case technicalEffects = "technical_effects"
        case scogsConclusion = "scogs_conclusion"
    }
}

// MARK: Extensions for enum decodables - default to an unknown value so we can filter it out
extension AnalyzeIngredientsResponseDTO.Status {
    public init(from decoder: Decoder) throws {
        self = try AnalyzeIngredientsResponseDTO.Status(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
extension IngredientInsightDTO.InsightType {
    public init(from decoder: Decoder) throws {
        self = try IngredientInsightDTO.InsightType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .none
    }
}
extension IngredientInsightDTO.Code {
    public init(from decoder: Decoder) throws {
        self = try IngredientInsightDTO.Code(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}