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
}

// https://medium.com/@cafielo/how-to-detect-notch-screen-in-swift-56271827625d
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first{ $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}