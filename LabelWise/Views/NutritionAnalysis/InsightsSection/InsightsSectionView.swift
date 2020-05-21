//
//  InsightsSectionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-10.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct InsightsSectionView: View {
    private static let MessageSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    
    private let viewModel: ViewModel
    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack(alignment: .leading, spacing: InsightsSectionView.MessageSpacing) {
            Group {
                ForEach(0..<self.viewModel.displayedInsightViewModels.count, id: \.self) { idx in
                    AnalysisIconTextView(vm: self.viewModel.displayedInsightViewModels[idx])
                }
            }
            // A workaround for multiline text in ScrollView
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: View model
extension InsightsSectionView {
    struct ViewModel {
        private let severeCautionInsightViewModels: [AnalysisIconTextView.ViewModel]
        private let warnCautionInsightViewModels: [AnalysisIconTextView.ViewModel]
        private let positiveInsightViewModels: [AnalysisIconTextView.ViewModel]
        var displayedInsightViewModels: [AnalysisIconTextView.ViewModel] {
            // Severe warnings first, followed by caution & positive
            severeCautionInsightViewModels +
            warnCautionInsightViewModels +
            positiveInsightViewModels
        }
        var hasMessages: Bool {
            return severeCautionInsightViewModels.count + warnCautionInsightViewModels.count
                    + positiveInsightViewModels.count > 0
        }

        init(insights: [NutritionInsightDTO], nutrition: Nutrition) {
            var severeCautionInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            var warnCautionInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            var positiveInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            insights.forEach { insight in
                let message = insight.code.getStringDescription(with: nutrition)
                let vm = AnalysisIconTextView.ViewModel(
                    text: message,
                    icon: insight.type.getAssociatedIcon(),
                    color: insight.type.getAssociatedColor()
                )
                switch insight.type {
                case .positive:
                    positiveInsightViewModels.append(vm)
                case .cautionWarn:
                    warnCautionInsightViewModels.append(vm)
                case .cautionSevere:
                    severeCautionInsightViewModels.append(vm)
                case .none:
                    AppLogging.warn("Unparseable type found for code \(insight.code.rawValue)")
                }
            }
            self.severeCautionInsightViewModels = severeCautionInsightViewModels
            self.warnCautionInsightViewModels = warnCautionInsightViewModels
            self.positiveInsightViewModels = positiveInsightViewModels
        }
    }
}

// MARK: Extension to get description from code
extension NutritionInsightDTO.Code {
    func getStringDescription(with nutrition: Nutrition) -> String {
        switch self {
        case .lowSodium:
            return "This has a low amount of sodium (\(StringFormatters.formatNutrientAmount(nutrition.sodium, unit: .milligrams)))."
        case .lowSugar:
            return "This has a low amount of sugar (\(StringFormatters.formatNutrientAmount(nutrition.sugar)))."
        case .highFiber:
            return "This has a lot of fiber (\(StringFormatters.formatNutrientAmount(nutrition.fiber)))."
        case .highProtein:
            return "This has a lot of protein (\(StringFormatters.formatNutrientAmount(nutrition.protein)))."
        case .highSodium:
            return "This has a lot of sodium (\(StringFormatters.formatNutrientAmount(nutrition.sodium, unit: .milligrams)))."
        case .highSugar:
            return "This has a lot of sugar (\(StringFormatters.formatNutrientAmount(nutrition.sugar)))."
        case .lowFiber:
            return "This does not have a lot of fiber (\(StringFormatters.formatNutrientAmount(nutrition.fiber)))."
        case .highSatFat:
            return "This has a lot of saturated fat (\(StringFormatters.formatNutrientAmount(nutrition.satFat)))."
        case .highCholesterol:
            return "This has a lot of cholesterol (\(StringFormatters.formatNutrientAmount(nutrition.cholesterol, unit: .milligrams)))."
        case .unknown:
            return ""
        }
    }
}

struct InsightsSectionView_Previews: PreviewProvider {
    private static let vm = InsightsSectionView.ViewModel(
        insights: PreviewNutritionModels.MultipleInsightsPerType,
        nutrition: PreviewNutritionModels.FullyParsedNutrition
    )
    
    static var previews: some View {
        ColorSchemePreview {
            InsightsSectionView(vm: vm)
        }.previewLayout(.sizeThatFits)
    }
}
