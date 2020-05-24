//
//  IngredientInfoView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct AnalyzedIngredientInfoBodyView: View {
    private static let InsightLinePadding: CGFloat = CGFloat.App.Layout.Padding
    private static let NoInsightsTextFont: Font = Font.App.SmallText
    private static let NoInsightsTextColor: Color = Color.App.SecondaryText

    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    private var noInsightsView: some View {
        // Centered if we show no insights
        HStack {
            Spacer()
            Text("No insights for this ingredient.")
                .withAppStyle(font: AnalyzedIngredientInfoBodyView.NoInsightsTextFont, color: AnalyzedIngredientInfoBodyView.NoInsightsTextColor)
            Spacer()
        }
    }
    private var insightsView: some View {
        // Show an icon textview for each insight that we get
        // Aligned to left if we show insights
        HStack {
            VStack(alignment: .leading, spacing: AnalyzedIngredientInfoBodyView.InsightLinePadding) {
                ForEach(0..<self.viewModel.insightViewModels.count, id: \.self) { idx in
                    AnalysisIconTextView(vm: self.viewModel.insightViewModels[idx])
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    var body: some View {
        if self.viewModel.showNoInsightsText {
            self.noInsightsView
        } else {
            self.insightsView
        }
    }
}

// MARK: View model
extension AnalyzedIngredientInfoBodyView {
    struct ViewModel {
        private let dto: AnalyzedIngredientDTO
        var showNoInsightsText: Bool {
            dto.insights.isEmpty
        }
        var insightViewModels: [AnalysisIconTextView.ViewModel] {
            var positiveInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            var cautionWarningInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            var severeWarningInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            self.dto.insights.forEach { insight in
                let vm = AnalysisIconTextView.ViewModel(
                    text: insight.code.getStringDescription(),
                    icon: insight.type.getAssociatedIcon(),
                    color: insight.type.getAssociatedColor(),
                    font: Font.App.SmallText
                )
                switch insight.type {
                case .positive:
                    positiveInsightViewModels.append(vm)
                case .cautionWarning:
                    cautionWarningInsightViewModels.append(vm)
                case .severeWarning:
                    severeWarningInsightViewModels.append(vm)
                case .none:
                    AppLogging.warn("Unparseable type found for code \(insight.code.rawValue)")
                }
            }
            // Severe first, but since these are specific to one ingredient, chances are we only have one type
            return severeWarningInsightViewModels + cautionWarningInsightViewModels + positiveInsightViewModels
        }

        init(dto: AnalyzedIngredientDTO) {
            self.dto = dto
        }
    }
}

// MARK: String description of insight codes
extension IngredientInsightDTO.Code {
    func getStringDescription() -> String {
        switch self {
        case .addedSugar:
            return "This is a known synonym for added sugar."
        case .notGras:
            return "This is not in the FDA's GRAS (Generally Recognized as Safe) database."
        case .scogs1:
            return """
                   This additive has sufficient research to verify its safety (FDA SCOGS Conclusion 1).
                   """
        case .scogs2:
            return """
                   This additive has sufficient research to verify its safety (FDA SCOGS Conclusion 2).
                   """
        case .scogs3:
            return """
                   There is scientific uncertainty around this additive's safety for consumption (FDA SCOGS Conclusion 3).
                   """
        case .scogs4:
            return """
                   There is some scientific evidence to show that this additive is harmful to public health (FDA SCOGS Conclusion 4).
                   """
        case .scogs5:
            return """
                   This additive lacks scientific evidence to fully confirm its safety (FDA SCOGS Conclusion 5).
                   """
        case .unknown:
            return ""
        }
    }
}

struct AnalyzedIngredientInfoBodyView_Previews: PreviewProvider {
    private static let cautionWarningVm = AnalyzedIngredientInfoBodyView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientDextrose)
    private static let multipleWarningsVm = AnalyzedIngredientInfoBodyView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientMultipleInsights)
    private static let noInsightsVm = AnalyzedIngredientInfoBodyView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientNoInsights)

    static var previews: some View {
        ColorSchemePreview {
            Group {
                AnalyzedIngredientInfoBodyView(vm: cautionWarningVm)
                AnalyzedIngredientInfoBodyView(vm: multipleWarningsVm)
                AnalyzedIngredientInfoBodyView(vm: noInsightsVm)
            }
            .background(Color.App.BackgroundSecondaryFillColor)
            .padding()
        }
        .frame(width: 500)
        .previewLayout(.sizeThatFits)
    }
}
