//
//  AppView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine

// Standard view for label scanning and analyzing
struct AppView: View {
    @ObservedObject private var viewModel: ViewModel = ViewModel()

    var body: some View {
        getViewFromViewState()
    }
    
    @ViewBuilder func getViewFromViewState() -> some View {
        // Switch statement does not work here
        if viewModel.viewState == .scanLabel {
            LabelScannerView(vm: self.getLabelScannerViewVm())
        } else if viewModel.viewState == .analyzeNutrition {
            NutritionAnalysisView(vm: self.getNutritionAnalysisViewVm())
        } else {
            // TODO: Errorview and loadingview here
            EmptyView()
        }
    }

    // TODO: Consider computed variable instead
    private func getLabelScannerViewVm() -> LabelScannerView.ViewModel {
        return LabelScannerView.ViewModel(onLabelScanned: self.viewModel.onLabelScanned)
    }

    private func getNutritionAnalysisViewVm() -> NutritionAnalysisView.ViewModel {
        return NutritionAnalysisView.ViewModel(
                analysisService: LabelAnalysisService(),
                onReturnToLabelScannerCallback: self.viewModel.onReturnToLabelScannerTapped
        )
    }
}

typealias LabelScannedCallback = (LabelImage, AnalyzeType) -> ()

extension AppView {
    class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .scanLabel
        @Published var scannedImage: LabelImage? = nil

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

        }

    }
}
extension AppView.ViewModel {
    enum ViewState {
        case scanLabel
        case analyzeNutrition
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
