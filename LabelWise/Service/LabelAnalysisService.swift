//
// Created by Frank Jia on 2020-04-23.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

class LabelAnalysisService {
    static let BaseUrl = "https://41b288c4.ngrok.io"
    static let NutritionImageUrl = BaseUrl + "/nutrition/image"
    static let IngredientsImageUrl = BaseUrl + "/ingredients/image"

    func analyzeNutrition(base64Image: String) -> ServicePublisher<AnalyzeNutritionResponse> {
        ServiceFuture<AnalyzeNutritionResponse> { promise in
            self.analyzeNutrition(base64Image: base64Image) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    private func analyzeNutrition(base64Image: String, onComplete: @escaping ServiceCallback<AnalyzeNutritionResponse>) {
        let requestParams = AnalyzeNutritionRequest(type: .nutrition, base64Image: base64Image)
        AF.request(LabelAnalysisService.NutritionImageUrl, method: .post,
                        parameters: requestParams, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: AnalyzeNutritionResponse.self) { response in
                    switch response.result {
                    case let .success(result):
                        onComplete(.success(result))
                    case let .failure(error):
                        onComplete(.failure(AppError("Error analyzing nutrition", wrappedError: error)))
                    }
                }
    }

}