//
//  IconTextViews.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-08.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: Main view
struct AnalysisIconTextView: View {
    private static let IconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let TextFont: Font = Font.App.NormalText
    
    private let text: String
    private let type: TextType
    private var icon: Image {
        self.type.getIcon()
    }
    private var color: Color {
        self.type.getColor()
    }
    
    init(text: String, type: TextType) {
        self.text = text
        self.type = type
    }
    
    var body: some View {
        HStack(alignment: .center) {
            self.icon
                .resizable()
                .frame(width: AnalysisIconTextView.IconSize, height: AnalysisIconTextView.IconSize)
                .foregroundColor(self.color)
            Text(self.text)
                .withStyle(font: AnalysisIconTextView.TextFont, color: self.color)
                .multiline()
        }
    }
}
// MARK: Icon text type
extension AnalysisIconTextView {
    enum TextType {
        case positive
        case cautionWarning
        case severeWarning
        
        func getIcon() -> Image {
            switch self {
            case .positive:
                return Image.App.CheckmarkCircle
            case .cautionWarning:
                return Image.App.ExclamationMarkCircle
            case .severeWarning:
                return Image.App.XMarkCircle
            }
        }
        
        func getColor() -> Color {
            switch self {
            case .positive:
                return Color.App.AppGreen
            case .cautionWarning:
                return Color.App.AppYellow
            case .severeWarning:
                return Color.App.AppRed
            }
        }
    }
}

struct AnalysisIconTextView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            VStack(alignment: .leading) {
                AnalysisIconTextView(text: "Positive Text", type: .positive)
                
                AnalysisIconTextView(text: "Warning Text", type: .cautionWarning)
                
                AnalysisIconTextView(text: "Severe Warning Text On Multiple Lines", type: .severeWarning)
            }
            .frame(width: 200)
            .padding()
            .background(Color.App.BackgroundSecondaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
