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
        let NormalIcon: CGFloat = 24
        let LargeIcon: CGFloat = 64
    }

    struct LayoutDimens {
        // Padding
        let extraLargePadding: CGFloat = 48
        let largePadding: CGFloat = 24
        let normalPadding: CGFloat = 16
        let smallPadding: CGFloat = 8
        let extraSmallPadding: CGFloat = 4

        let CornerRadius: CGFloat = 16

        // For drop shadows
        let ShadowRadius: CGFloat = 4
    }
}

extension CGFloat {
    static let App = AppDimensions()
}


extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180
    }
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}
extension Int {
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}