//
// Created by Frank Jia on 2020-05-09.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

extension Double {
    func toPercent() -> Double {
        return self * 100
    }
    func toDecimal() -> Double {
        return self / 100
    }
}

extension Array where Element == NutritionInsightDTO {
    func sortedWithMostNegativeFirst() -> [Element] {
        return self.sorted { one, other in one.type.rawValue < other.type.rawValue }
    }
    func sortedWithMostPositiveFirst() -> [Element] {
        return self.sorted { one, other in one.type.rawValue > other.type.rawValue }
    }
}

struct NutritionViewUtils {
    static func getPercentage(amount: Double?, total: Double?) -> Double? {
        guard let amount = amount, let total = total, total > 0 else {
            return nil
        }
        return (amount / total).toPercent()
    }
    static func getDailyValuePercentage(amount: Double?, dailyValue: Double) -> Double? {
        guard let amount = amount else {
            return nil
        }
        guard dailyValue > 0 else {
            return 100
        }
        return (amount / dailyValue).toPercent()
    }
}