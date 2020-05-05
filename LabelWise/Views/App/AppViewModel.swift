//
// Created by Frank Jia on 2020-05-04.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// Passed up from label scanner
typealias LabelScannedCallback = (LabelImage, AnalyzeType) -> ()

// MARK: Root view model
extension AppView {
    class ViewModel: ObservableObject {
        @Published private(set) var viewState: ViewState = .scanLabel
        @Published private(set) var scannedImage: LabelImage? = nil
    }
}
// MARK: Actions for view model
extension AppView.ViewModel {
    // Callback from LabelScannerView to kick off analysis
    func onLabelScanned(image: LabelImage, type: AnalyzeType) {
        self.scannedImage = image
        switch type {
        case .ingredients:
            break
        case .nutrition:
            self.viewState = .analyzeNutrition
        }
    }
    // Callback from analysis views to return to label scanning
    func onReturnToLabelScannerTapped() {
        self.scannedImage = nil
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