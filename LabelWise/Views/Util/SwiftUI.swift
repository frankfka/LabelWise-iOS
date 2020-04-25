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
}