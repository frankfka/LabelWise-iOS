//
// Created by Frank Jia on 2020-05-06.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

extension String {
    static let NoNumberPlaceholderText: String = "--"    
}
extension Double {
    func toString(numDecimalDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = numDecimalDigits
        formatter.maximumFractionDigits = numDecimalDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}