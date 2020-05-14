//
//  NutritionAnalysisView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisRootView: View {

    @ObservedObject private var viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Child view models
    private var resultsViewVm: (NutritionAnalysisResultsHeaderView.ViewModel, NutritionAnalysisResultsView.ViewModel)? {
        self.viewModel.analysisResult.map {
            (
                NutritionAnalysisResultsHeaderView.ViewModel(dto: $0),
                NutritionAnalysisResultsView.ViewModel(dto: $0)
            )
        }
    }
    // Child views
    private var loadingView: some View {
        FullScreenLoadingView(loadingText: "Analyzing", onCancelCallback: self.returnToLabelScanner)
    }
    private var insufficientInfoErrorView: some View {
        FullScreenErrorView(errorMessage: "We couldn't find enough nutritional information. Try taking another picture.",
                onTryAgainTapped: self.returnToLabelScanner)
    }
    private var genericErrorView: some View {
        FullScreenErrorView(errorMessage: "Something went wrong. We couldn't analyze the label.",
                onTryAgainTapped: self.returnToLabelScanner)
    }
    @ViewBuilder
    private var resultsView: some View {
        if resultsViewVm != nil {
            resultsViewVm.map({ (headerVm, bodyVm) in
                getResultsView(headerVm: headerVm, bodyVm: bodyVm)
            })
        } else {
            // If we show resultsView without a proper VM, this is an error case
            genericErrorView
        }
    }
    private func getResultsView(headerVm: NutritionAnalysisResultsHeaderView.ViewModel,
                                bodyVm: NutritionAnalysisResultsView.ViewModel) -> some View {
        let headerBackground = NutritionAnalysisResultsHeaderView(vm: headerVm)
        return AnalysisScrollView(
                header: headerBackground,
                headerBackground: headerBackground.background,
                onBackPressedCallback: self.returnToLabelScanner) { parentGeometry in
                    NutritionAnalysisResultsView(vm: bodyVm, parentSize: parentGeometry.size)
        }
    }

    // MARK: Main view
    @ViewBuilder
    var body: some View {
        if self.viewModel.state == .displayResults {
            resultsView
        } else if self.viewModel.state == .analyzing {
            loadingView
        } else if self.viewModel.state == .insufficientInfo {
            insufficientInfoErrorView
        } else {
            genericErrorView
        }
    }

    // MARK: Actions
    private func returnToLabelScanner() {
        self.viewModel.send(.returnToScanner)
    }
}

struct NutritionAnalysisView_Previews: PreviewProvider {

    private static let vm = NutritionAnalysisRootView.ViewModel()

    static var previews: some View {
        NutritionAnalysisRootView(vm: vm)
    }
}
