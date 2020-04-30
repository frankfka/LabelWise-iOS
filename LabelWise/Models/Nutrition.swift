//
// Created by Frank Jia on 2020-04-29.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

// Total daily values, we just use the standard DV's for now
struct DailyNutritionValues {
    let calories: Double
    let carbohydrates: Double
    let sugar: Double
    let fiber: Double
    let protein: Double
    let fat: Double
    let satFat: Double
    let cholesterol: Double
    let sodium: Double

    init(calories: Double = 2000, carbohydrates: Double = 300, sugar: Double = 30,
         fiber: Double = 25, protein: Double = 80, fat: Double = 65,
         satFat: Double = 20, cholesterol: Double = 300, sodium: Double = 2400) {
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.sugar = sugar
        self.fiber = fiber
        self.protein = protein
        self.fat = fat
        self.satFat = satFat
        self.cholesterol = cholesterol
        self.sodium = sodium
    }
}