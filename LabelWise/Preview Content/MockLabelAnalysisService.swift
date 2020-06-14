//
// Created by Frank Jia on 2020-05-06.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine

class MockAnalysisService: LabelAnalysisService {
    // Helper functions to convert into publishers
    static func getServicePublisher<T>(response: T? = nil) -> ServicePublisher<T> {
        if let resp = response {
            return Just(resp)
                    .setFailureType(to: AppError.self)
                    .delay(for: .seconds(1), scheduler: RunLoop.main) // Simulate loading
                    .eraseToAnyPublisher()
        } else {
            return Fail(outputType: T.self, failure: AppError(""))
                    .delay(for: .seconds(1), scheduler: RunLoop.main)  // Simulate loading
                    .eraseToAnyPublisher()
        }
    }

    // Manually set these properties to change the desired response - error is returned if property is nil
    var analyzeNutritionResponse: AnalyzeNutritionResponseDTO? = nil
    var analyzeIngredientsResponse: AnalyzeIngredientsResponseDTO? = nil

    func analyzeNutrition(img: Data) -> ServicePublisher<AnalyzeNutritionResponseDTO> {
        return MockAnalysisService.getServicePublisher(response: self.analyzeNutritionResponse)
    }

    func analyzeIngredients(img: Data) -> ServicePublisher<AnalyzeIngredientsResponseDTO> {
        return MockAnalysisService.getServicePublisher(response: self.analyzeIngredientsResponse)
    }
}
