import Foundation
import SwiftUI

// TODO: https://uxdesign.cc/a-five-minute-guide-to-better-typography-for-ios-4e3c2715ceb4
struct AppTypography {
    let Heading: Font = .system(size: CGFloat.App.Font.Heading, weight: .bold, design: .default)
    let Subtitle: Font = .system(size: CGFloat.App.Font.Subtitle, weight: .medium, design: .default)
    let LargeTextBold: Font = .system(size: CGFloat.App.Font.Large, weight: .semibold, design: .default)
    let LargeText: Font = .system(size: CGFloat.App.Font.Large, weight: .regular, design: .default)
    let NormalTextBold: Font = .system(size: CGFloat.App.Font.Normal, weight: .medium, design: .default)
    let NormalText: Font = .system(size: CGFloat.App.Font.Normal, weight: .regular, design: .default)
    let SmallText: Font = .system(size: CGFloat.App.Font.Small, weight: .regular, design: .default)
}

extension Font {
    static let App = AppTypography()
}

extension Text {
    func withStyle(font: Font = Font.App.NormalText, color: Color = Color.App.SecondaryText) -> Text {
        return self
            .font(font)
            .foregroundColor(color)
    }
}