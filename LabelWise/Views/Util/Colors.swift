import Foundation
import SwiftUI

struct AppColors {
    let white: Color = .white

    // Text colors
    let textDark: Color = Color.init(.label)
    let text: Color = Color.init(.secondaryLabel)
    let textLight: Color = Color.init(.tertiaryLabel)

    // Primary theme colors
    let primaryUIColor: UIColor = .systemGreen
    let primary: Color = Color.init(.systemGreen)

    // Background colors
    let overlay: Color = Color.black.opacity(0.8)

    // Indicator colors
    let ProteinIndicator: Color = Color("ProteinIndicator")
    let ProteinIndicatorLight: Color = Color("ProteinIndicatorLight")
    let CarbIndicator: Color = Color("CarbIndicator")
    let CarbIndicatorLight: Color = Color("CarbIndicatorLight")
    let FatIndicator: Color = Color("FatIndicator")
    let FatIndicatorLight: Color = Color("FatIndicatorLight")
}

extension Color {
    static let App = AppColors()
}