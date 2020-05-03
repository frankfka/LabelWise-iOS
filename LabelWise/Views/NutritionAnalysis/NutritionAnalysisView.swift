//
//  NutritionAnalysisView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-30.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// TODO: Extract this to be more generic!
struct NutritionAnalysisView: View {
    
    @State private var headerVisible: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                if self.headerVisible {
                    VStack {
                        Text("Header")
                        Text("Header")
                        Text("Header")
                    }
                    .fillWidth()
                    .padding(.top, geometry.safeAreaInsets.top)
                    .padding(.bottom, 12)
                    .background(Color.App.AppGreen)
                }
                VStack {
                    Spacer()
                    Text("Loading")
                    Spacer()
                }
                .frame(minHeight: geometry.size.height)
                .fillWidth()
                .background(HalfRoundedRectangle(cornerRadius: 12).foregroundColor(.white))
                .offset(x: 0, y: -12)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .background(
            VStack {
                Rectangle().foregroundColor(Color.App.AppGreen)
                Rectangle().foregroundColor(Color.white)

            }
        )
        .onAppear {
            self.displayAnimation()
        }
    }
    
    private func displayAnimation() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            self.headerVisible = true
        }
    }
    
}

struct NutritionAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionAnalysisView()
    }
}
