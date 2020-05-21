//
//  IconTextViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-08.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct AnalysisIconTextView: View {
    private static let IconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let TextFont: Font = Font.App.NormalText
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        HStack(alignment: .center) {
            self.viewModel.icon
                .resizable()
                .frame(width: AnalysisIconTextView.IconSize, height: AnalysisIconTextView.IconSize)
                .foregroundColor(self.viewModel.color)
            Text(self.viewModel.text)
                .withStyle(font: AnalysisIconTextView.TextFont, color: self.viewModel.color)
                .multiline()
        }
    }
}
// MARK: View Model
extension AnalysisIconTextView {
    struct ViewModel {
        let text: String
        let icon: Image
        let color: Color

        init(text: String, icon: Image, color: Color) {
            self.text = text
            self.icon = icon
            self.color = color
        }
    }
}

struct AnalysisIconTextView_Previews: PreviewProvider {

    private static let positiveVm = AnalysisIconTextView.ViewModel(
        text: "Positive Text",
        icon: Image.App.CheckmarkCircle,
        color: Color.App.AppGreen
    )

    private static let cautionVm = AnalysisIconTextView.ViewModel(
        text: "Caution Text",
        icon: Image.App.ExclamationMarkCircle,
        color: Color.App.AppYellow
    )

    private static let severeVm = AnalysisIconTextView.ViewModel(
        text: "Severe Warning Text On Multiple Lines",
        icon: Image.App.XMarkCircle,
        color: Color.App.AppRed
    )

    static var previews: some View {
        ColorSchemePreview {
            VStack(alignment: .leading) {
                AnalysisIconTextView(vm: positiveVm)
                AnalysisIconTextView(vm: cautionVm)
                AnalysisIconTextView(vm: severeVm)
            }
            .frame(width: 200)
            .padding()
            .background(Color.App.BackgroundSecondaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
