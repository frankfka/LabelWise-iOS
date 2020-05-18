//
// Created by Frank Jia on 2020-05-06.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine

class MockAnalysisService: LabelAnalysisService {

    // Helper functions to convert into publishers
    static func getNutritionResponsePublisher(response: AnalyzeNutritionResponseDTO? = nil) -> ServicePublisher<AnalyzeNutritionResponseDTO> {
        if let resp = response {
            return Just(resp)
                    .setFailureType(to: AppError.self)
                    .delay(for: .seconds(1), scheduler: RunLoop.main) // Simulate loading
                    .eraseToAnyPublisher()
        } else {
            return Fail(outputType: AnalyzeNutritionResponseDTO.self, failure: AppError("")).eraseToAnyPublisher()
        }
    }

    var analyzeNutritionResponse: AnalyzeNutritionResponseDTO? = nil // Error returned if nil

    func analyzeNutrition(base64Image: String) -> ServicePublisher<AnalyzeNutritionResponseDTO> {
        return MockAnalysisService.getNutritionResponsePublisher(response: self.analyzeNutritionResponse)
    }
}
