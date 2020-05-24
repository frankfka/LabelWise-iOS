//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// A protocol for picker types
protocol PickerViewModel {
    var selectedIndex: Binding<Int> { get set }
    var items: [String] { get }
}

// Standard icons and colors from insights
extension IngredientInsightDTO.InsightType {
    func getAssociatedIcon() -> Image {
        switch self {
        case .positive:
            return Image.App.CheckmarkCircle
        case .cautionWarning:
            return Image.App.ExclamationMarkCircle
        case .severeWarning:
            return Image.App.XMarkCircle
        case .none:
            return Image.App.XMarkCircle
        }
    }
    func getAssociatedColor() -> Color {
        switch self {
        case .positive:
            return Color.App.AppGreen
        case .cautionWarning:
            return Color.App.AppYellow
        case .severeWarning:
            return Color.App.AppRed
        case .none:
            return Color.App.AppRed
        }
    }
}
extension NutritionInsightDTO.InsightType {
    func getAssociatedIcon() -> Image {
        switch self {
        case .positive:
            return Image.App.CheckmarkCircle
        case .cautionWarning:
            return Image.App.ExclamationMarkCircle
        case .severeWarning:
            return Image.App.XMarkCircle
        case .none:
            return Image.App.XMarkCircle
        }
    }
    func getAssociatedColor() -> Color {
        switch self {
        case .positive:
            return Color.App.AppGreen
        case .cautionWarning:
            return Color.App.AppYellow
        case .severeWarning:
            return Color.App.AppRed
        case .none:
            return Color.App.AppRed
        }
    }
}