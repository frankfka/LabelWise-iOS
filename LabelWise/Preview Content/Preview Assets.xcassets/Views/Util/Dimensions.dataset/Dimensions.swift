import Foundation
import SwiftUI

struct AppDimensions {

    let Font = FontDimens()
    let Icon = IconDimens()
    let Layout = LayoutDimens()

    struct FontDimens {
        let Small: CGFloat = 12
        let Normal: CGFloat = 16
        let Large: CGFloat = 20
        let Subtitle: CGFloat = 26
        let Heading: CGFloat = 34
    }

    struct IconDimens {
        let SmallIcon: CGFloat = 24
        let NormalIcon: CGFloat = 36
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