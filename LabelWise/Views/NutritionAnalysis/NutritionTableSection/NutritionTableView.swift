//
//  NutritionTableView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-15.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionTableRow: View {
    struct ViewModel {
        let label: String
        let value: String
        let dailyValue: String?
        let rowType: RowType
        
        init(label: String, value: String, dailyValue: String? = nil, rowType: RowType = .primary) {
            self.label = label
            self.value = value
            self.dailyValue = dailyValue
            self.rowType = rowType
        }
    }
    enum RowType {
        case primary
        case secondary
        var labelFont: Font {
            switch self {
            case .primary:
                return NutritionTableRow.PrimaryLabelFont
            case .secondary:
                return NutritionTableRow.SecondaryLabelFont
            }
        }
        var textColor: Color {
            switch self {
            case .primary:
                return NutritionTableRow.PrimaryLabelColor
            case .secondary:
                return NutritionTableRow.SecondaryLabelColor
            }
        }
    }
    
    private static let HorizontalPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let SecondaryHorizontalPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let VerticalPadding: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let PrimaryLabelFont: Font = Font.App.NormalTextBold
    private static let PrimaryLabelColor: Color = Color.App.Text
    private static let SecondaryLabelFont: Font = Font.App.NormalText
    private static let SecondaryLabelColor: Color = Color.App.SecondaryText
    private static let ValueFont: Font = Font.App.NormalText
    private static let DailyValueFont: Font = Font.App.SmallText
    private static let DailyValueColor: Color = Color.App.SecondaryText
    private static let DailyValueLeadingPadding: CGFloat = CGFloat.App.Layout.SmallestPadding
    
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(self.viewModel.label)
                .withStyle(font: self.viewModel.rowType.labelFont, color: self.viewModel.rowType.textColor)
                .conditionalModifier(self.viewModel.rowType == .secondary) {
                    $0.padding(.leading, NutritionTableRow.SecondaryHorizontalPadding)
                }
            self.viewModel.dailyValue.map {
                Text($0)
                    .withStyle(font: NutritionTableRow.DailyValueFont, color: NutritionTableRow.DailyValueColor)
                    .padding(.leading, NutritionTableRow.DailyValueLeadingPadding)
                }
            Spacer()
            Text(self.viewModel.value)
                .withStyle(font: NutritionTableRow.ValueFont, color: self.viewModel.rowType.textColor)
        }
        .padding(.horizontal, NutritionTableRow.HorizontalPadding)
        .padding(.vertical, NutritionTableRow.VerticalPadding)
    }
    
}

// MARK: View
struct NutritionTableView: View {
    
    private let viewModel: ViewModel
    
    init() {
        self.viewModel = ViewModel(nutrition: PreviewNutritionModels.FullyParsedNutrition)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.viewModel.rowViewModels.count, id: \.self) { index in
                Group {
                    NutritionTableRow(vm: self.viewModel.rowViewModels[index])
                    if self.viewModel.rowViewModels.showDividerAfter(index: index) {
                        Divider()
                    }
                }
            }
        }
    }
}

// MARK: View Model
extension NutritionTableView {
    struct ViewModel {
        private let nutrition: Nutrition
        var rowViewModels: [NutritionTableRow.ViewModel] {
            return [
                // Calories
                NutritionTableRow.ViewModel(label: "Calories", value: StringFormatters.formatNutrientAmount(nutrition.calories, unit: .none)),
                // Fats
                NutritionTableRow.ViewModel(
                    label: "Total Fat",
                    value: StringFormatters.formatNutrientAmount(nutrition.fat),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.fatDVPercent)
                ),
                NutritionTableRow.ViewModel(
                    label: "Saturated",
                    value: StringFormatters.formatNutrientAmount(nutrition.satFat),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.satFatDVPercent),
                    rowType: .secondary
                ),
                NutritionTableRow.ViewModel(
                    label: "Cholesterol",
                    value: StringFormatters.formatNutrientAmount(nutrition.cholesterol, unit: .milligrams),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.cholesterolDVPercent)
                ),
                // Sodium
                NutritionTableRow.ViewModel(
                    label: "Sodium",
                    value: StringFormatters.formatNutrientAmount(nutrition.sodium, unit: .milligrams),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.sodiumDVPercent)
                ),
                // Carbs
                NutritionTableRow.ViewModel(
                    label: "Carbohydrates",
                    value: StringFormatters.formatNutrientAmount(nutrition.carbohydrates),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.carbohydratesDVPercent)
                ),
                NutritionTableRow.ViewModel(
                    label: "Sugar",
                    value: StringFormatters.formatNutrientAmount(nutrition.sugar),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.sugarDVPercent),
                    rowType: .secondary
                ),
                NutritionTableRow.ViewModel(
                    label: "Fiber",
                    value: StringFormatters.formatNutrientAmount(nutrition.fiber),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.fiberDVPercent),
                    rowType: .secondary
                ),
                // Protein
                NutritionTableRow.ViewModel(
                    label: "Protein",
                    value: StringFormatters.formatNutrientAmount(nutrition.protein),
                    dailyValue: StringFormatters.formatDVPercent(nutrition.proteinDVPercent)
                )
            ]
        }
        
        init(nutrition: Nutrition) {
            self.nutrition = nutrition
        }
        
    }
}

struct NutritionTableView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionTableView()
    }
}
