import Foundation
import SwiftUI

// Reference: https://github.com/aaronbrethorst/SemanticUI
// Reference: https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
struct AppColors {
    let White: Color = .white

    // General UI Colors
    let Shadow: Color = Color.black.opacity(0.2)
    let Disabled: Color = Color(.systemGray)
    let Affirmative: Color = Color("AppGreen")
    let Destructive: Color = Color("AppRed")

    // Background and Fill Colors
    let BackgroundPrimaryFillColor: Color = Color(.systemBackground) // Fills main background (furthest back)
    let BackgroundSecondaryFillColor: Color = Color(.secondarySystemBackground) // Fills background for elements on top of main background
    let BackgroundTertiaryFillColor: Color = Color(.tertiarySystemBackground) // Fills background for elements on top of secondary background

    // Text colors
    let Text: Color = Color.init(.label)
    let SecondaryText: Color = Color.init(.secondaryLabel)
    let TertiaryText: Color = Color.init(.tertiaryLabel)

    // Primary theme colors
    let PrimaryUIColor: UIColor = UIColor(named: "AppGreen")!
    let Primary: Color = Color("AppGreen")

    // Background colors
    let Overlay: Color = Color.black.opacity(0.8)

    // Indicator colors
    let ProteinIndicator: Color = Color("AppPurple")
    let ProteinIndicatorLight: Color = Color("AppPurpleLight")
    let CarbIndicator: Color = Color("AppGreen")
    let CarbIndicatorLight: Color = Color("AppGreenLight")
    let FatIndicator: Color = Color("AppBlue")
    let FatIndicatorLight: Color = Color("AppBlueLight")
}

extension Color {
    static let App = AppColors()
}
