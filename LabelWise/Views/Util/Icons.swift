import Foundation
import SwiftUI

struct AppIcons {
    let LeftChevron: Image = Image(systemName: "chevron.left")
    let RightChevron: Image = Image(systemName: "chevron.right")
    let QuestionMarkCircleFill: Image = Image(systemName: "questionmark.circle.fill")
    let CheckmarkCircleFill: Image = Image(systemName: "checkmark.circle.fill")
    let XMarkCircle: Image = Image(systemName: "xmark.circle")
    let XMarkCircleFill: Image = Image(systemName: "xmark.circle.fill")
    let ExclamationMarkCircle: Image = Image(systemName: "exclamationmark.circle")
    let CheckmarkCircle: Image = Image(systemName: "checkmark.circle")
}

extension Image {
    static let App = AppIcons()
}
