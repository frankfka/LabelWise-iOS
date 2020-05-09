//
// Created by Frank Jia on 2020-05-04.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// Passed up from label scanner
typealias LabelScannedCallback = (LabelImage, AnalyzeType, Bool) -> () // TODO: 3rd argument is temp for testing

// MARK: Root view model
extension AppView {
    class ViewModel: ObservableObject {
        private let labelAnalysisService: LabelAnalysisService = LabelAnalysisServiceImpl() // TODO service injection: https://github.com/hmlongco/Resolver
        @Published private(set) var viewState: ViewState = .scanLabel
        private(set) var analyzeNutritionPublisher: ServicePublisher<AnalyzeNutritionResponseDTO>? = nil
    }
}
// MARK: Actions for view model
extension AppView.ViewModel {
    // Callback from LabelScannerView to kick off analysis
    func onLabelScanned(image: LabelImage, type: AnalyzeType, isTest: Bool) {
        switch type {
        case .ingredients:
            break
        case .nutrition:
            self.viewState = .analyzeNutrition
            if isTest {
                let parsedNutrition = PreviewNutritionModels.FullyParsedNutritionDto
                let response = AnalyzeNutritionResponseDTO(status: .complete, parsedNutrition: parsedNutrition, insights: [])
                self.analyzeNutritionPublisher = MockAnalysisService.getNutritionResponsePublisher(response: response)
            } else {
                self.analyzeNutritionPublisher = labelAnalysisService.analyzeNutrition(base64Image: image.compressedB64String)
            }
        }
    }
    // Callback from analysis views to return to label scanning
    func onReturnToLabelScannerTapped() {
        self.analyzeNutritionPublisher = nil
        self.viewState = .scanLabel
    }
}
// MARK: Addition models for view model
extension AppView.ViewModel {
    enum ViewState {
        case scanLabel
        case analyzeNutrition
    }
}