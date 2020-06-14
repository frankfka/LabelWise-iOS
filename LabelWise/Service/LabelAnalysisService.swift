//
// Created by Frank Jia on 2020-04-23.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

protocol LabelAnalysisService {
    func analyzeNutrition(img: Data) -> ServicePublisher<AnalyzeNutritionResponseDTO>
    func analyzeIngredients(img: Data) -> ServicePublisher<AnalyzeIngredientsResponseDTO>
}

class LabelAnalysisServiceImpl: LabelAnalysisService {
    private let apiKey: String
    private let baseUrl: String
    private var analyzeUrl: String {
        self.baseUrl + "/analyze/image-upload"
    }
    private var authHeaders: HTTPHeaders {
        ["X-API-Key": self.apiKey]
    }

    init(config: Configuration) {
        self.baseUrl = config.serviceBaseUrl
        self.apiKey = config.apiKey
    }

    func analyzeNutrition(img: Data) -> ServicePublisher<AnalyzeNutritionResponseDTO> {
        ServiceFuture<AnalyzeNutritionResponseDTO> { promise in
            self.dispatchRequest(img: img, analysisType: .nutrition) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    func analyzeIngredients(img: Data) -> ServicePublisher<AnalyzeIngredientsResponseDTO> {
        ServiceFuture<AnalyzeIngredientsResponseDTO> { promise in
            self.dispatchRequest(img: img, analysisType: .ingredients) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }

    private func dispatchRequest<ResponseDTO: Decodable>(img: Data, analysisType: AnalyzeType, onComplete: @escaping ServiceCallback<ResponseDTO>) {
        let requestDto = AnalysisRequestDTO(type: analysisType, img: img)
        AF.upload(
            multipartFormData: requestDto.createFormData,
            to: self.analyzeUrl,
            headers: self.authHeaders
        )
        .validate()
        .responseDecodable(of: ResponseDTO.self) { response in
            switch response.result {
            case let .success(result):
                onComplete(.success(result))
            case let .failure(error):
                onComplete(.failure(AppError("Error analyzing \(analysisType.rawValue): " + response.debugDescription, wrappedError: error)))
            }
        }
    }

}

// MARK: DTO Extensions
extension AnalysisRequestDTO {
    func createFormData(_ formData: MultipartFormData) {
        guard let analyzeTypeData = self.type.rawValue.data(using: String.Encoding.utf8) else {
            AppLogging.error("Could not convert analysis type \(self.type.rawValue) to String Data")
            return
        }
        formData.append(analyzeTypeData, withName: "type")
        formData.append(self.img, withName: "img", fileName: "img.jpg", mimeType: "image/jpg")
    }
}
