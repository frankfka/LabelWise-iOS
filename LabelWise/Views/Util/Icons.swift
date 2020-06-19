import Foundation
import SwiftUI

struct AppIcons {
    let Logo: Image = Image("Logo")
    let LeftChevron: Image = Image(systemName: "chevron.left")
    let RightChevron: Image = Image(systemName: "chevron.right")
    let QuestionMarkCircleFill: Image = Image(systemName: "questionmark.circle.fill")
    let CheckmarkCircleFill: Image = Image(systemName: "checkmark.circle.fill")
    let XMarkCircle: Image = Image(systemName: "xmark.circle")
    let XMarkCircleFill: Image = Image(systemName: "xmark.circle.fill")
    let ExclamationMarkCircle: Image = Image(systemName: "exclamationmark.circle")
    let CheckmarkCircle: Image = Image(systemName: "checkmark.circle")
    let OneCircleFill: Image = Image(systemName: "1.circle.fill")
    let TwoCircleFill: Image = Image(systemName: "2.circle.fill")
    let ThreeCircleFill: Image = Image(systemName: "3.circle.fill")
}

extension Image {
    static let App = AppIcons()
}
