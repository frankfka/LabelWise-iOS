import Foundation
import SwiftUI

// TODO: https://uxdesign.cc/a-five-minute-guide-to-better-typography-for-ios-4e3c2715ceb4
struct AppTypography {
    let heading: Font = .system(size: CGFloat.App.Font.large, weight: .semibold, design: .default)
    let normalText: Font = .system(size: CGFloat.App.Font.normal, weight: .medium, design: .default)
    let smallText: Font = .system(size: CGFloat.App.Font.small, weight: .regular, design: .default)
}

extension Font {
    static let App = AppTypography()
}

extension Text {
    func withStyle(font: Font = Font.App.normalText, color: Color = Color.App.text) -> Text {
        return self
                .font(font)
                .foregroundColor(color)
    }
}