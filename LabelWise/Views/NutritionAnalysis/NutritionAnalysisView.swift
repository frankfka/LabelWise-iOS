//
//  NutritionAnalysisView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisView: View {
    
    @State private var loading: Bool = true
    @State private var error: Bool = false
    
    private var header: some View {
        Text("Loading")
            .withStyle(font: Font.App.heading, color: Color.white)
    }
    private var headerBackgroundColor: Color {
        Color.App.AppGreen
    }
    
    var body: some View {
        VStack {
            if self.loading {
                FullScreenLoadingView(loadingText: "Analyzing")
            } else {
                AnalysisScrollView(header: self.header, headerBackground: self.headerBackgroundColor) {
                    VStack {
                        Spacer()
                        Text("Test")
                        Spacer()
                    }
                    .fillWidthAndHeight()
                }
            }
        }.onAppear(perform: self.testOnAppear)
    }
    
    private func testOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loading = false
        }
    }
}

struct NutritionAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionAnalysisView()
    }
}
