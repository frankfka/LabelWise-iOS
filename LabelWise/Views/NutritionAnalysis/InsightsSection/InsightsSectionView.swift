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
                ForEach(0..<self.viewModel.insightViewModels.count, id: \.self) { idx in
                    AnalysisIconTextView(vm: self.viewModel.insightViewModels[idx])
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
        private let insights: [NutritionInsightDTO]
        private let nutrition: Nutrition
        var insightViewModels: [AnalysisIconTextView.ViewModel] {
            self.insights.filter { insight in
                if insight.code == .unknown && insight.type == .none {
                    AppLogging.warn("Unknown insight with code \(insight.code), type \(insight.type)")
                    return false
                }
                return true
            }.sorted { one, two in
                // Positive first
                one.type > two.type
            }.map { insight in
                AnalysisIconTextView.ViewModel(
                    text: insight.code.getStringDescription(with: self.nutrition),
                    icon: insight.type.getAssociatedIcon(),
                    color: insight.type.getAssociatedColor()
                )
            }
        }
        var hasMessages: Bool {
            insightViewModels.count > 0
        }

        init(insights: [NutritionInsightDTO], nutrition: Nutrition) {
            self.insights = insights
            self.nutrition = nutrition
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
