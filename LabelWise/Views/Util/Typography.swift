import Foundation
import SwiftUI

struct AppTypography {
    let heading: Font = .system(size: CGFloat.App.Font.large, weight: .semibold, design: .default)
    let normalText: Font = .system(size: CGFloat.App.Font.normal, weight: .medium, design: .default)
    let normalTextUIFont: UIFont = .systemFont(ofSize: CGFloat.App.Font.normal, weight: .medium)
    let smallText: Font = .system(size: CGFloat.App.Font.small, weight: .medium, design: .default)

    let boldAccentText: Font = .system(size: CGFloat.App.Font.large, weight: .medium, design: .default)
    let boldNormalText: Font = .system(size: CGFloat.App.Font.normal, weight: .medium, design: .default)
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