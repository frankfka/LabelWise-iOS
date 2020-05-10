//
//  NutritionAnalysisView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// TODO: either fix via state machine orr a warning onAppear, but we shouldnt show views htat dont match state (ex. have results but result not initialized)
struct NutritionAnalysisRootView: View {

    @ObservedObject private var viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Child view models
    private var resultsViewVm: (NutritionAnalysisResultsHeaderView.ViewModel, NutritionAnalysisResultsView.ViewModel)? {
        self.viewModel.analysisResult.map({
            (
                NutritionAnalysisResultsHeaderView.ViewModel(dto: $0),
                NutritionAnalysisResultsView.ViewModel(dto: $0)
            )
        })
    }
    // Child views
    private var loadingView: some View {
        FullScreenLoadingView(loadingText: "Analyzing", onCancelCallback: self.viewModel.onReturnToLabelScannerCallback)
    }
    private var errorView: some View {
        FullScreenErrorView(errorMessage: "We couldn't analyze the label.", onTryAgainTapped: self.viewModel.onReturnToLabelScannerCallback)
    }
    @ViewBuilder
    private var resultsView: some View {
        if resultsViewVm != nil {
            resultsViewVm.map({ (headerVm, bodyVm) in
                getResultsView(headerVm: headerVm, bodyVm: bodyVm)
            })
        } else {
            // If we show resultsView without a proper VM, this is an error case
            errorView
        }
    }
    private func getResultsView(headerVm: NutritionAnalysisResultsHeaderView.ViewModel,
                                bodyVm: NutritionAnalysisResultsView.ViewModel) -> some View {
        let headerBackground = NutritionAnalysisResultsHeaderView(vm: headerVm)
        return AnalysisScrollView(
                header: headerBackground,
                headerBackground: headerBackground.background,
                onBackPressedCallback: self.viewModel.onReturnToLabelScannerCallback) { parentGeometry in
                    NutritionAnalysisResultsView(vm: bodyVm, parentSize: parentGeometry.size)
        }
    }

    // MARK: Main view
    @ViewBuilder
    var body: some View {
        if self.viewModel.viewState == .displayResults {
            resultsView
        } else if self.viewModel.viewState == .analyzing {
            loadingView
        } else {
            errorView
        }
    }
}

struct NutritionAnalysisView_Previews: PreviewProvider {

    private static let vm: NutritionAnalysisRootView.ViewModel = NutritionAnalysisRootView.ViewModel()

    static var previews: some View {
        NutritionAnalysisRootView(vm: vm)
    }
}
