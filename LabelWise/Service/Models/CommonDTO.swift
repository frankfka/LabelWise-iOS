//
// Created by Frank Jia on 2020-05-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation


// MARK: Request
struct AnalysisRequestDTO {
    let type: AnalyzeType
    let base64Image: String
}
extension AnalysisRequestDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case base64Image = "b64_img"
    }
}