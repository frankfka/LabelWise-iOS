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
    @ViewBuilder
    private var resultsView: some View {
        EmptyView()  // Show nothing if resultsVm is nil
        resultsViewVm.map({ (headerVm, bodyVm) in
            getResultsView(headerVm: headerVm, bodyVm: bodyVm)
        })
    }
    private func getResultsView(headerVm: NutritionAnalysisResultsHeaderView.ViewModel,
                                bodyVm: NutritionAnalysisResultsView.ViewModel) -> some View {
        let headerBackground = NutritionAnalysisResultsHeaderView()
        return AnalysisScrollView(
                header: headerBackground,
                headerBackground: headerBackground.background) {
            NutritionAnalysisResultsView()
        }
    }

    // MARK: Main view
    @ViewBuilder
    var body: some View {
        if self.viewModel.viewState == .displayResults {
            resultsView
        } else if self.viewModel.viewState == .analyzing {
            FullScreenLoadingView(loadingText: "Analyzing")
        } else {
            FullScreenErrorView()
        }
    }
}

struct NutritionAnalysisView_Previews: PreviewProvider {

    private static let vm: NutritionAnalysisRootView.ViewModel = NutritionAnalysisRootView.ViewModel(analysisService: LabelAnalysisService())

    static var previews: some View {
        NutritionAnalysisRootView(vm: vm)
    }
}
