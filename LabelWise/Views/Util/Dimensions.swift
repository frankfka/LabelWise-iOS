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
        let ExtraSmallIcon: CGFloat = 16
        let SmallIcon: CGFloat = 24
        let NormalIcon: CGFloat = 36
        let LargeIcon: CGFloat = 64
        let ExtraLargeIcon: CGFloat = 128
    }

    struct LayoutDimens {
        // Padding
        let LargestPadding: CGFloat = 48
        let LargePadding: CGFloat = 36
        let MediumPadding: CGFloat = 24
        let Padding: CGFloat = 16
        let SmallPadding: CGFloat = 8
        let SmallestPadding: CGFloat = 4

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
