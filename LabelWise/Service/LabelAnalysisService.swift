//
// Created by Frank Jia on 2020-04-23.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

protocol LabelAnalysisService {
    func analyzeNutrition(base64Image: String) -> ServicePublisher<AnalyzeNutritionResponseDTO>
    func analyzeIngredients(base64Image: String) -> ServicePublisher<AnalyzeIngredientsResponseDTO>
}

class LabelAnalysisServiceImpl: LabelAnalysisService {
    private let apiKey: String
    private let baseUrl: String
    private var analyzeUrl: String {
        self.baseUrl + "/analyze/image"
    }
    private var authHeaders: HTTPHeaders {
        ["X-API-Key": self.apiKey]
    }

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

    func analyzeIngredients(base64Image: String) -> ServicePublisher<AnalyzeIngredientsResponseDTO> {
        ServiceFuture<AnalyzeIngredientsResponseDTO> { promise in
            self.analyzeIngredients(base64Image: base64Image) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    private func analyzeNutrition(base64Image: String, onComplete: @escaping ServiceCallback<AnalyzeNutritionResponseDTO>) {
        let requestParams = AnalysisRequestDTO(type: .nutrition, base64Image: base64Image)
        AF.request(self.analyzeUrl, method: .post,
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

    private func analyzeIngredients(base64Image: String, onComplete: @escaping ServiceCallback<AnalyzeIngredientsResponseDTO>) {
        let requestParams = AnalysisRequestDTO(type: .ingredients, base64Image: base64Image)
        AF.request(self.analyzeUrl, method: .post,
                        parameters: requestParams, encoder: JSONParameterEncoder.default, headers: self.authHeaders)
                .responseDecodable(of: AnalyzeIngredientsResponseDTO.self) { response in
                    switch response.result {
                    case let .success(result):
                        onComplete(.success(result))
                    case let .failure(error):
                        onComplete(.failure(AppError("Error analyzing ingredients", wrappedError: error)))
                    }
                }
    }

}
