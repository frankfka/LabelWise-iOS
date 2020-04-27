//
// Created by Frank Jia on 2020-04-27.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// Type picker to choose between nutrition/ingredients
struct LabelTypePickerView: View {

    private let viewModel: PickerViewModel

    init(vm: PickerViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        Picker("Mode", selection: self.viewModel.selectedIndex) {
            ForEach(0..<self.viewModel.items.count, id: \.self) { index in
                Text(self.viewModel.items[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        // TODO: dark mode, need to use systembackground
        // Makes sure we can read the text by adding a non-transparent background
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}