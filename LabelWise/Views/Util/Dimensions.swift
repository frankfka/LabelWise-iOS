import Foundation
import SwiftUI

struct AppDimensions {

    let Font = FontDimens()
    let Icon = IconDimens()
    let Layout = LayoutDimens()

    struct FontDimens {
        let small: CGFloat = 12
        let normal: CGFloat = 16
        let large: CGFloat = 20
    }

    struct IconDimens {
        let normal: CGFloat = 24
        let largeButton: CGFloat = 64
    }

    struct LayoutDimens {
        // Padding
        let extraLargePadding: CGFloat = 48
        let largePadding: CGFloat = 24
        let normalPadding: CGFloat = 16
        let smallPadding: CGFloat = 8
        let extraSmallPadding: CGFloat = 4

        let cornerRadius: CGFloat = 24

        // Icons
        let iconSize: CGFloat = 24
    }
}

extension CGFloat {
    static let App = AppDimensions()
}