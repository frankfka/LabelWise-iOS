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
    static let BaseUrl = "https://97013df1.ngrok.io/"
    static let NutritionImageUrl = BaseUrl + "/nutrition/image"
    static let IngredientsImageUrl = BaseUrl + "/ingredients/image"

    func analyzeNutrition(base64Image: String) -> ServicePublisher<AnalyzeNutritionResponseDTO> {
        ServiceFuture<AnalyzeNutritionResponseDTO> { promise in
            self.analyzeNutrition(base64Image: base64Image) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    private func analyzeNutrition(base64Image: String, onComplete: @escaping ServiceCallback<AnalyzeNutritionResponseDTO>) {
        let requestParams = AnalyzeNutritionRequestDTO(type: .nutrition, base64Image: base64Image)
        AF.request(LabelAnalysisServiceImpl.NutritionImageUrl, method: .post,
                        parameters: requestParams, encoder: JSONParameterEncoder.default)
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