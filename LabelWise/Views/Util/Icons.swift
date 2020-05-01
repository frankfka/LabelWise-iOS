import Foundation
import SwiftUI

struct AppIcons {
    let QuestionMarkCircleFill: Image = Image(systemName: "questionmark.circle.fill")
    let CheckmarkCircleFill: Image = Image(systemName: "checkmark.circle.fill")
    let XMarkCircleFill: Image = Image(systemName: "xmark.circle.fill")
}

extension Image {
    static let App = AppIcons()
}
