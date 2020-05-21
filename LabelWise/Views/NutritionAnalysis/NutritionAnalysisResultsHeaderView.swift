//
//  NutritionAnalysisResultsHeaderView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-04.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutritionAnalysisResultsHeaderView: View {

    private static let CaloriesNumericalFont: Font = Font.App.Heading
    private static let CaloriesDescriptionFont: Font = Font.App.LargeText
    private static let NumInsightsFont: Font = Font.App.LargeText
    private static let ElementColor: Color = Color.App.White
    private static let CalorieTextSpacing: CGFloat = CGFloat.App.Layout.SmallestPadding
    private static let CalorieSectionBottomPadding: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let VerticalElementSpacing: CGFloat = CGFloat.App.Layout.SmallPadding

    private let viewModel: ViewModel
    init(vm: ViewModel) {
        self.viewModel = vm
    }

    // Shared background with AnalysisScrollView
    var background: some View {
        self.viewModel.backgroundColor
    }

    var body: some View {
        VStack(spacing: NutritionAnalysisResultsHeaderView.VerticalElementSpacing) {
            HStack(alignment: .bottom, spacing: NutritionAnalysisResultsHeaderView.CalorieTextSpacing) {
                Spacer()
                Text(self.viewModel.caloriesText)
                    .withAppStyle(font: NutritionAnalysisResultsHeaderView.CaloriesNumericalFont,
                            color: NutritionAnalysisResultsHeaderView.ElementColor)
                Text("cals")
                    .withAppStyle(font: NutritionAnalysisResultsHeaderView.CaloriesDescriptionFont,
                            color: NutritionAnalysisResultsHeaderView.ElementColor)
                    // Custom alignment guide so it looks more aligned
                    .alignmentGuide(.bottom) { d in d[.bottom] + 4 }
                Spacer()
            }
            .padding(.bottom, NutritionAnalysisResultsHeaderView.CalorieSectionBottomPadding)
            AnalysisIconTextView(vm: self.viewModel.parseResultTextViewVm)
            self.viewModel.numInsightsTextViewVm.map {
                AnalysisIconTextView(vm: $0)
            }
        }
        .fillWidth()
        .background(self.background)
    }
}

extension NutritionAnalysisResultsHeaderView {
    struct ViewModel {
        private static let PositiveIcon: Image = Image.App.CheckmarkCircle
        private static let CautionIcon: Image = Image.App.ExclamationMarkCircle

        // Root data
        private let insights: [NutritionInsightDTO]
        private let nutrition: Nutrition
        private let parseStatus: AnalyzeNutritionResponseDTO.Status
        // Computed view constants
        var numCautionWarnings: Int {
            insights.filter { $0.type == .cautionWarn }.count
        }
        var numSevereWarnings: Int {
            insights.filter { $0.type == .cautionSevere }.count
        }
        var hasWarnings: Bool {
            numCautionWarnings + numSevereWarnings > 0
        }
        var numPositiveWarnings: Int {
            insights.filter { $0.type == .positive }.count
        }
        // Background color
        var backgroundColor: Color {
            if numSevereWarnings > 0 {
                return Color.App.AppRed
            } else if numCautionWarnings > 0 {
                return Color.App.AppYellow
            }
            return Color.App.AppGreen
        }
        var caloriesText: String {
            if let calories = nutrition.calories {
                return calories.toString(numDecimalDigits: 1)
            }
            return StringFormatters.NoNumberPlaceholderText
        }
        // Shown if we have returned insights
        private var numInsightsText: String? {
            let numInsights = insights.count
            if numInsights > 0 {
                let numWarnings = numCautionWarnings + numSevereWarnings
                if numWarnings > 0 {
                    return " \(numWarnings) nutrition warning\(numWarnings > 1 ? "s" : "")"
                } else {
                    return "\(numInsights) insight\(numInsights > 1 ? "s" : "")"
                }
            }
            return nil
        }
        var numInsightsTextViewVm: AnalysisIconTextView.ViewModel? {
            numInsightsText.map {
                let icon = self.hasWarnings ? ViewModel.CautionIcon : ViewModel.PositiveIcon
                return AnalysisIconTextView.ViewModel(
                    text: $0,
                    icon: icon,
                    color: NutritionAnalysisResultsHeaderView.ElementColor
                )
            }
        }
        // Shows the status of the nutrition parsing
        var parseResultTextViewVm: AnalysisIconTextView.ViewModel {
            let text: String
            let icon: Image
            if self.parseStatus == .complete {
                text = "Parsed complete nutritional profile"
                icon = ViewModel.PositiveIcon
            } else {
                text = "Nutritional information is incomplete"
                icon = ViewModel.CautionIcon
            }
            return AnalysisIconTextView.ViewModel(
                text: text,
                icon: icon,
                color: NutritionAnalysisResultsHeaderView.ElementColor
            )
        }

        init(nutrition: Nutrition, insights: [NutritionInsightDTO], parseStatus: AnalyzeNutritionResponseDTO.Status) {
            self.parseStatus = parseStatus
            self.nutrition = nutrition
            self.insights = insights
        }
    }
}

struct NutritionAnalysisResultsHeaderView_Previews: PreviewProvider {
    private static let vm = NutritionAnalysisResultsHeaderView.ViewModel(
        nutrition: PreviewNutritionModels.FullyParsedNutrition,
        insights: [],
        parseStatus: .complete
    )

    static var previews: some View {
        NutritionAnalysisResultsHeaderView(vm: vm)
    }
}
