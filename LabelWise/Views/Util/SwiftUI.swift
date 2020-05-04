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
    
    @ViewBuilder func `conditionalModifier`<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T : View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// https://medium.com/@cafielo/how-to-detect-notch-screen-in-swift-56271827625d
struct DeviceProperties {
    static let current = DeviceProperties()

    var hasNotch: Bool {
        let bottom = getWindow()?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }

    private func getWindow() -> UIWindow? {
        return UIApplication.shared.windows.first{ $0.isKeyWindow }
    }
}
