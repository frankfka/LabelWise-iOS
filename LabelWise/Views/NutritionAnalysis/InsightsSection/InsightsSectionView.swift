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
                ForEach(self.viewModel.positiveMessages, id: \.self) { msg in
                    AnalysisIconTextView(text: msg, type: .positive)
                }
                ForEach(self.viewModel.warnCautionMessages, id: \.self) { msg in
                    AnalysisIconTextView(text: msg, type: .cautionWarning)
                }
                ForEach(self.viewModel.severeCautionMessages, id: \.self) { msg in
                    AnalysisIconTextView(text: msg, type: .severeWarning)
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
        let severeCautionMessages: [String]
        let warnCautionMessages: [String]
        let positiveMessages: [String]
        var hasMessages: Bool {
            return severeCautionMessages.count + warnCautionMessages.count + positiveMessages.count > 0
        }
        
        init(dto: AnalyzeNutritionResponseDTO) {
            var severeCautionMessages: [String] = []
            var warnCautionMessages: [String] = []
            var positiveMessages: [String] = []
            let parsedNutrition = dto.parsedNutrition
            dto.insights.forEach { insight in
                let message = insight.code.getStringDescription(with: parsedNutrition)
                switch insight.type {
                case .positive:
                    positiveMessages.append(message)
                case .cautionWarn:
                    warnCautionMessages.append(message)
                case .cautionSevere:
                    severeCautionMessages.append(message)
                case .none:
                    AppLogging.warn("Unparseable type found for code \(insight.code.rawValue)")
                }
            }
            self.severeCautionMessages = severeCautionMessages
            self.warnCautionMessages = warnCautionMessages
            self.positiveMessages = positiveMessages
        }
    }
}

// MARK: Extension to get description from code
extension NutritionInsightDTO.Code {
    func getStringDescription(with nutrition: AnalyzeNutritionResponseDTO.ParsedNutrition) -> String {
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
    private static let vm = InsightsSectionView.ViewModel(dto: AnalyzeNutritionResponseDTO(
        status: .complete,
        parsedNutrition: PreviewNutritionModels.FullyParsedNutritionDto,
        insights: PreviewNutritionModels.MultipleInsightsPerType
    ))
    
    static var previews: some View {
        ColorSchemePreview {
            InsightsSectionView(vm: vm)
        }.previewLayout(.sizeThatFits)
    }
}
