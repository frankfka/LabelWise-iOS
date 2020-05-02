//
// Created by Frank Jia on 2020-05-01.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// Wrapper for previewing light + dark mode
struct ColorSchemePreview<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        Group {
            content()
            content()
                .environment(\.colorScheme, .dark)
        }
    }
}