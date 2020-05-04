import SwiftUI

struct ContentView: View {

    var body: some View {
        LabelScannerView()
    }
}

// Hosting controller for content view that has dynamic status bar style
class ContentHostingController: UIHostingController<ContentView> {
    private var currentStatusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentStatusBarStyle
    }
    // Passing nil will set the style to default
    // TODO: maybe an enum here?
    func changeStatusBarStyle(showDarkText: Bool?) {
        if let showDarkText = showDarkText {
            self.currentStatusBarStyle = showDarkText ? .darkContent : .lightContent
        } else {
            self.currentStatusBarStyle = .default
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
