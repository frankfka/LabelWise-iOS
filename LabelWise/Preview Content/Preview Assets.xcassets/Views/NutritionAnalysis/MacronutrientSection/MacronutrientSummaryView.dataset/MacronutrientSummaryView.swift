//
// Created by Frank Jia on 2020-04-29.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

extension Double {
    func toPercent() -> Double {
        return self * 100
    }
}

struct MacronutrientSummaryView: View {

    struct ViewModel {
        let dailyAllowance: DailyNutritionValues
        let proteinAmount: Double?
        var proteinDVPercent: Double? {
            if let proteinAmount = proteinAmount, dailyAllowance.protein > 0 {
                return (proteinAmount / dailyAllowance.protein).toPercent()
            }
            return nil
        }
        let fatAmount: Double?
        var fatDVPercent: Double? {
            if let fatAmount = fatAmount, dailyAllowance.fat > 0 {
                return (fatAmount / dailyAllowance.fat).toPercent()
            }
            return nil
        }
        let carbsAmount: Double?
        var carbsDVPercent: Double? {
            if let carbsAmount = carbsAmount, dailyAllowance.carbohydrates > 0 {
                return (carbsAmount / dailyAllowance.carbohydrates).toPercent()
            }
            return nil
        }

        // Child view models
        var ringViewModel: MacronutrientRings.ViewModel {
            MacronutrientRings.ViewModel(carbPercentage: carbsDVPercent, proteinPercentage: proteinDVPercent, fatPercentage: fatDVPercent)
        }


        init(dto: AnalyzeNutritionResponseDTO.ParsedNutrition,
             dailyAllowance: DailyNutritionValues = DailyNutritionValues()) {
            self.carbsAmount = dto.carbohydrates
            self.fatAmount = dto.fat
            self.proteinAmount = dto.protein
            self.dailyAllowance = dailyAllowance
        }
    }

    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        HStack {
            MacronutrientRings(vm: viewModel.ringViewModel)
        }
    }
}

struct MacronutrientSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
