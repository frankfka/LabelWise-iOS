//
// Created by Frank Jia on 2020-04-25.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

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

struct AnalyzeNutritionResponseDTO {
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

    let parsedNutrition: ParsedNutrition
    let warnings: [NutritionWarningDTO]
}
extension AnalyzeNutritionResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case parsedNutrition = "parsed_nutrition"
        case warnings = "warnings"
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
        case satFat = "saturated_fat" // TODO: Double check this
        case cholesterol = "cholesterol"
        case sodium = "sodium"
    }
}

struct NutritionWarningDTO {
    enum Level: Int, Codable {
        case none = 0
        case caution = 1
        case severe = 2
    }
    enum Code: String, Codable {
        case highSodium = "HIGH_SODIUM"
        case highSugar = "HIGH_SUGAR"
        case lowFiber = "LOW_FIBER"
        case highSatFat = "HIGH_SAT_FAT"
        case highCholesterol = "HIGH_CHOLESTEROL"
    }

    let code: Code
    let level: Level
}
extension NutritionWarningDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case level = "level"
    }
}


// MARK: Extensions for enum codables
// TODO: test non-conforming types from alamofire
extension NutritionWarningDTO.Level {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if let value = try? values.decode(Int.self, forKey: .count) {
//            self = .count(number: value)
//            return
//        }
//        if let value = try? values.decode(String.self, forKey: .title) {
//            self = .title(value)
//            return
//        }
//        throw PostTypeCodingError.decoding("Whoops! \(dump(values))")
//    }
}
