import SwiftUI

struct ContentView: View {
    // TODO: In the future, onboarding views will be conditionally shown here
    var body: some View {
        AppView()
    }
}

// Hosting controller for content view that has dynamic status bar style
class ContentHostingController: UIHostingController<ContentView> {
    private var currentStatusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentStatusBarStyle
    }
    func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        self.currentStatusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
