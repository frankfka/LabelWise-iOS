import Foundation
import SwiftUI

// Reference: https://github.com/aaronbrethorst/SemanticUI
// Reference: https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
struct AppColors {
    private static let AppGreen: Color = Color("AppGreen")
    private static let AppRed: Color = Color("AppRed")
    private static let AppYellow: Color = Color("AppYellow")
    private static let AppPurple: Color = Color("AppPurple")
    private static let AppBlue: Color = Color("AppBlue")

    let White: Color = .white

    // Theme colors
    let AppGreen: Color = AppColors.AppGreen
    let AppRed: Color = AppColors.AppRed
    let AppYellow: Color = AppColors.AppYellow
    let AppPurple: Color = AppColors.AppPurple
    let AppBlue: Color = AppColors.AppBlue

    // General UI Colors
    let Shadow: Color = Color.black.opacity(0.2)
    let Disabled: Color = Color(.systemGray)
    let Affirmative: Color = AppColors.AppGreen
    let Destructive: Color = AppColors.AppRed
    let Error: Color = AppColors.AppRed

    // Background and Fill Colors
    let BackgroundPrimaryFillColor: Color = Color(.systemBackground) // Fills main background (furthest back)
    let BackgroundSecondaryFillColor: Color = Color(.secondarySystemBackground) // Fills background for elements on top of main background
    let BackgroundTertiaryFillColor: Color = Color(.tertiarySystemBackground) // Fills background for elements on top of secondary background
    let PrimaryFillColor: Color = Color(.systemFill) // Fills thin elements on top of background

    // Text colors
    let Text: Color = Color.init(.label)
    let SecondaryText: Color = Color.init(.secondaryLabel)
    let TertiaryText: Color = Color.init(.tertiaryLabel)

    // Primary theme colors
    let PrimaryUIColor: UIColor = UIColor(named: "AppGreen")!
    let Primary: Color = AppColors.AppGreen

    // Background colors
    let Overlay: Color = Color.black.opacity(0.8)

    // Indicator colors
    let ProteinIndicator: Color = AppColors.AppPurple
    let ProteinIndicatorLight: Color = Color("AppPurpleLight")
    let CarbIndicator: Color = AppColors.AppGreen
    let CarbIndicatorLight: Color = Color("AppGreenLight")
    let FatIndicator: Color = AppColors.AppBlue
    let SatFatIndicator: Color = AppColors.AppYellow
    let CholesterolIndicator: Color = AppColors.AppPurple
    let FatIndicatorLight: Color = Color("AppBlueLight")
    let SugarIndicator: Color = AppColors.AppRed
    let FiberIndicator: Color = AppColors.AppBlue

}

extension Color {
    static let App = AppColors()
}
