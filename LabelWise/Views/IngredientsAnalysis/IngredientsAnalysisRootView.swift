//
//  IngredientsAnalysisRootView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-23.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct IngredientsAnalysisRootView: View {

    @ObservedObject private var viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Child view models
    private var resultsViewVm: (IngredientsAnalysisHeaderView.ViewModel, IngredientsAnalysisResultsView.ViewModel)? {
        self.viewModel.analysisResult.map {
            return (
                IngredientsAnalysisHeaderView.ViewModel(analyzedIngredients: $0.analyzedIngredients),
                IngredientsAnalysisResultsView.ViewModel(dto: $0)
            )
        }
    }
    // Child views
    private var loadingView: some View {
        FullScreenLoadingView(loadingText: "Analyzing", onCancelCallback: self.viewModel.returnToLabelScanner)
    }
    private var noIngredientsParsedErrorView: some View {
        FullScreenErrorView(errorMessage: "We couldn't parse any ingredients.",
                onTryAgainTapped: self.viewModel.returnToLabelScanner)
    }
    private var genericErrorView: some View {
        FullScreenErrorView(errorMessage: "Something went wrong. We couldn't analyze the label.",
                onTryAgainTapped: self.viewModel.returnToLabelScanner)
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
    private func getResultsView(headerVm: IngredientsAnalysisHeaderView.ViewModel,
                                bodyVm: IngredientsAnalysisResultsView.ViewModel) -> some View {
        let headerBackground = IngredientsAnalysisHeaderView(vm: headerVm)
        return AnalysisScrollView(
                header: headerBackground,
                headerBackground: headerBackground.background,
                onBackPressedCallback: self.viewModel.returnToLabelScanner) { parentGeometry in
            IngredientsAnalysisResultsView(vm: bodyVm)
        }
    }

    @ViewBuilder
    var body: some View {
        if self.viewModel.state == .displayResults {
            resultsView
        } else if self.viewModel.state == .analyzing {
            loadingView
        } else if self.viewModel.state == .nonParsed {
            noIngredientsParsedErrorView
        } else {
            genericErrorView
        }
    }
}

struct IngredientsAnalysisRootView_Previews: PreviewProvider {
    private static let initialLoadingVm = IngredientsAnalysisRootView.ViewModel()

    static var previews: some View {
        ColorSchemePreview {
            IngredientsAnalysisRootView(vm: initialLoadingVm)
        }
    }
}
