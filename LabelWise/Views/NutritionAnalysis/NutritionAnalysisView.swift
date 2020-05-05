//
//  NutritionAnalysisView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisView: View {

    @ObservedObject private var viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        self.getViewFromViewState()
    }

    @ViewBuilder private func getViewFromViewState() -> some View {
        if self.viewModel.viewState == .displayResults {
            self.getResultsView()
        } else if self.viewModel.viewState == .analyzing {
            FullScreenLoadingView(loadingText: "Analyzing")
        } else if self.viewModel.viewState == .error {
            Text("Error")
        } else {
            // TODO: Maybe throw a fatal error here?
            EmptyView()
        }
    }

    // TODO: Computed var https://www.swiftbysundell.com/tips/computed-properties-vs-methods/
    private func getResultsView() -> some View {
        let headerView = NutritionAnalysisResultsHeaderView()
        let headerBackground = Color.App.AppGreen
        return
        AnalysisScrollView(header: headerView, headerBackground: headerBackground) {
            NutritionAnalysisResultsView()
        }
    }

}

struct NutritionAnalysisView_Previews: PreviewProvider {

    private static let vm: NutritionAnalysisView.ViewModel = NutritionAnalysisView.ViewModel(analysisService: LabelAnalysisService())

    static var previews: some View {
        NutritionAnalysisView(vm: vm)
    }
}
