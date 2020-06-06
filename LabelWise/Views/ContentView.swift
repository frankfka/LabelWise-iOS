import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()

    @ViewBuilder
    var body: some View {
        if viewModel.state == .loading {
            FullScreenLoadingView()
        } else if viewModel.state == .noPermissions {
            Text("No permissions")
        } else if viewModel.state == .onboarding {
            OnboardingView(onGetStartedTapped: self.viewModel.onOnboardingComplete)
        } else if viewModel.state == .mainApp {
            AppView()
        } else {
            FullScreenErrorView()
        }
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
