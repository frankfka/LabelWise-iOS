//
//  AnalysisScrollViewHelpers.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// Modifier for expanding section - pretty simple, just hides the ugly if-else
struct ExpandingSectionModifier: ViewModifier {
    @Binding private var isExpanded: Bool
    
    init(isExpanded: Binding<Bool>) {
        self._isExpanded = isExpanded
    }
    
    func body(content: Content) -> some View {
        Group {
            if self.isExpanded {
                content
            } else {
                EmptyView()
            }
        }
    }
}

// Background with multiple colors to be consistent with different header/footer colors on overscroll
struct VerticalTiledBackground<Background: View>: View {
    
    private let views: [Background]
    
    init(views: [Background]) {
        self.views = views
    }
    
    var body: some View {
        VStack {
            ForEach(0..<views.count, id: \.self) { index in
                self.views[index]
            }
        }
    }
}
