//
// Created by Frank Jia on 2020-04-23.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

protocol LabelAnalysisService {
    func analyzeNutrition(base64Image: String) -> ServicePublisher<AnalyzeNutritionResponseDTO>
}

class LabelAnalysisServiceImpl: LabelAnalysisService {
    private let apiKey: String
    private let baseUrl: String
    private var nutritionImageUrl: String { self.baseUrl + "/nutrition/image" }
    private var ingredientsImageUrl: String { self.baseUrl + "/ingredients/image" }
    private var authHeaders: HTTPHeaders { ["X-API-Key": self.apiKey] }

    init(config: Configuration) {
        self.baseUrl = config.serviceBaseUrl
        self.apiKey = config.apiKey
    }

    func analyzeNutrition(base64Image: String) -> ServicePublisher<AnalyzeNutritionResponseDTO> {
        ServiceFuture<AnalyzeNutritionResponseDTO> { promise in
            self.analyzeNutrition(base64Image: base64Image) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    private func analyzeNutrition(base64Image: String, onComplete: @escaping ServiceCallback<AnalyzeNutritionResponseDTO>) {
        let requestParams = AnalyzeNutritionRequestDTO(
            type: .nutrition,
            base64Image: base64Image
        )
        AF.request(self.nutritionImageUrl, method: .post,
                        parameters: requestParams, encoder: JSONParameterEncoder.default, headers: self.authHeaders)
                .responseDecodable(of: AnalyzeNutritionResponseDTO.self) { response in
                    switch response.result {
                    case let .success(result):
                        onComplete(.success(result))
                    case let .failure(error):
                        onComplete(.failure(AppError("Error analyzing nutrition", wrappedError: error)))
                    }
                }
    }
}
