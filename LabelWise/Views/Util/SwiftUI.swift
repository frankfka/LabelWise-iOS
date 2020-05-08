//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    // https://swiftwithmajid.com/2019/12/04/must-have-swiftui-extensions/
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    func fillWidth() -> some View {
        return self.frame(minWidth: 0, maxWidth: .infinity)
    }
    func fillHeight() -> some View {
        return self.frame(minHeight: 0, maxHeight: .infinity)
    }
    func fillWidthAndHeight() -> some View {
        return self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    @ViewBuilder func conditionalModifier<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
extension Text {
    func singleLine() -> some View {
        self.lineLimit(1)
    }
    func multiline() -> some View {
        self.lineLimit(nil)
    }
}

extension UIApplication {
    // https://stackoverflow.com/questions/57063142/swiftui-status-bar-color
    class func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let vc = UIApplication.getKeyWindow()?.rootViewController as? ContentHostingController {
            vc.changeStatusBarStyle(style)
        }
    }
    // https://medium.com/@cafielo/how-to-detect-notch-screen-in-swift-56271827625d
    class var hasNotch: Bool {
        let bottom = UIApplication.getKeyWindow()?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    private class func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first{ $0.isKeyWindow }
    }
}