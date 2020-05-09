//
// Created by Frank Jia on 2020-05-06.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

extension Double {
    func toString(numDecimalDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = numDecimalDigits
        formatter.maximumFractionDigits = numDecimalDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

struct StringFormatters {
    static let NoNumberPlaceholderText: String = "--"

    static func formatNutrientAmount(_ amount: Double?) -> String {
        let amountStr: String
        if let amount = amount {
            amountStr = "\(amount.toString(numDecimalDigits: 0))"
        } else {
            amountStr = NoNumberPlaceholderText
        }
        return "\(amountStr)g"
    }
    static func formatDVPercent(_ percent: Double?) -> String {
        let dvString: String
        if let percent = percent {
            dvString = percent.toString(numDecimalDigits: 0)
        } else {
            dvString = NoNumberPlaceholderText
        }
        return "(\(dvString)% DV)"
    }
}