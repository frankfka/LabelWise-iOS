//
// Created by Frank Jia on 2020-04-25.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct NutritionWarningDTO: Codable {
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