//
//  AppView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI
import Combine

// TODO: should check for camera permission, then pop to onboarding if it was turned off
// Root view for label scanning and analyzing
struct MainAppView: View {
    // Primary view model
    @ObservedObject private var viewModel: ViewModel = ViewModel()
    // Child view models
    private var labelScannerViewVm: LabelScannerView.ViewModel {
        LabelScannerView.ViewModel(onLabelScanned: self.viewModel.onLabelScanned)
    }
    private var nutritionAnalysisViewVm: NutritionAnalysisRootView.ViewModel {
        NutritionAnalysisRootView.ViewModel(
            resultPublisher: self.viewModel.analyzeNutritionPublisher,
            onReturnToLabelScannerCallback: self.viewModel.onReturnToLabelScannerTapped
        )
    }
    private var ingredientsAnalysisViewVm: IngredientsAnalysisRootView.ViewModel {
        IngredientsAnalysisRootView.ViewModel(
                resultPublisher: self.viewModel.analyzeIngredientsPublisher,
                onReturnToLabelScannerCallback: self.viewModel.onReturnToLabelScannerTapped
        )
    }

    @ViewBuilder
    var body: some View {
        if viewModel.state == .scanLabel {
            LabelScannerView(vm: self.labelScannerViewVm)
        } else if viewModel.state == .analyzeNutrition {
            NutritionAnalysisRootView(vm: self.nutritionAnalysisViewVm)
        } else if viewModel.state == .analyzeIngredients {
            IngredientsAnalysisRootView(vm: self.ingredientsAnalysisViewVm)
        } else {
            // Generic error view - this should never be called
            FullScreenErrorView().onAppear { AppLogging.error("Invalid view state in AppView") }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
