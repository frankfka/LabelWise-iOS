//
//  NutritionAnalysisViewModel.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension NutritionAnalysisRootView {
    class ViewModel: ObservableObject {
        // View properties
        @Published var viewState: ViewState = .analyzing
        @Published var analysisError: Error? = nil
        @Published var analysisResult: AnalyzeNutritionResponseDTO? = nil

        // Callbacks
        let onReturnToLabelScannerCallback: VoidCallback?

        // Services
        private let labelAnalysisService: LabelAnalysisService

        // Cancellables
        private var analysisCancellable: AnyCancellable? = nil

        // Cancel any in-flight actions
        deinit {
            AppLogging.debug("Deinit NutritionAnalysisViewModel")
            analysisCancellable?.cancel()
        }

        init(analysisService: LabelAnalysisService, onReturnToLabelScannerCallback: VoidCallback? = nil) {
            self.labelAnalysisService = analysisService
            self.onReturnToLabelScannerCallback = onReturnToLabelScannerCallback
            // TODO: Temporary
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.viewState = .displayResults
                self.analysisResult = AnalyzeNutritionResponseDTO(parsedNutrition: NutritionPreviewModels.FullyParsedNutritionDto, warnings: [])
            }
        }

//        private func analyzeNutrition() {
//            self.labelAnalysisService.analyzeNutrition(base64Image: imageToAnalyze.compressedB64String)
//                .sink(receiveCompletion: { [weak self] completion in
//                    if let err = completion.getError() {
//                        print(err)
//                    }
//                }, receiveValue: { [weak self] response in
//                    print(response.parsedNutrition.calories ?? "None")
//                })
//                .store(in: &disposables)
//        }
    }
}

// Additional models for vm
extension NutritionAnalysisRootView.ViewModel {
    // State of the analysis view
    enum ViewState {
        case analyzing
        case error
        case displayResults
    }
}
