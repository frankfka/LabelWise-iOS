import Foundation
import SwiftUI

struct AppIcons {
    let labelScannerHelp: Image = Image(systemName: "questionmark.circle.fill")
    let labelScannerConfirmImage: Image = Image(systemName: "checkmark.circle.fill")
    let labelScannerCancelImage: Image = Image(systemName: "xmark.circle.fill")
}

extension Image {
    static let App = AppIcons()
}
