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
        @Published var analysisResult: AnalyzeNutritionResponseDTO? = nil

        // Callbacks
        let onReturnToLabelScannerCallback: VoidCallback?

        // Cancellables
        private var analysisCancellable: AnyCancellable?

        // Cancel any in-flight actions
        deinit {
            AppLogging.debug("Deinit NutritionAnalysisViewModel")
            analysisCancellable?.cancel()
        }

        // Technically, the publisher is non-nullable but this will just hang in a cancellable loading state
        init(resultPublisher: ServicePublisher<AnalyzeNutritionResponseDTO>? = nil,
             onReturnToLabelScannerCallback: VoidCallback? = nil) {
            self.onReturnToLabelScannerCallback = onReturnToLabelScannerCallback
            if resultPublisher == nil {
                AppLogging.error("Initializing NutritionAnalysisRootViewModel with null resultPublisher")
            }
            self.analysisCancellable = resultPublisher?.sink(receiveCompletion: { [weak self] completion in
                if let err = completion.getError() {
                    AppLogging.error("Error analyzing nutrition: \(String(describing: err))")
                    self?.viewState = .error
                }
            }, receiveValue: { [weak self] response in
                AppLogging.debug("Success analyzing nutrition. Parsed \(response.parsedNutrition.calories ?? 0) calories")
                self?.viewState = .displayResults
                self?.analysisResult = response
            })
        }
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
