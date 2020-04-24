//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

// A protocol for picker types
protocol PickerViewModel {
    var selectedIndex: Binding<Int> { get set }
    var items: [String] { get }
}