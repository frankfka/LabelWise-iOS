import Foundation
import SwiftUI

struct AppColors {
    let White: Color = .white

    // General UI Colors
    let Shadow: Color = Color.black.opacity(0.2)
    let Disabled: Color = Color(.systemGray)
    let Affirmative: Color = Color("AppGreen")
    let Destructive: Color = Color("AppRed")

    // Text colors
    let textDark: Color = Color.init(.label)
    let text: Color = Color.init(.secondaryLabel)
    let textLight: Color = Color.init(.tertiaryLabel)

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