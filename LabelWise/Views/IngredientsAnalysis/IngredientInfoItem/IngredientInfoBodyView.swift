//
//  IngredientInfoView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct IngredientInfoBodyView: View {
    private static let InsightLinePadding: CGFloat = CGFloat.App.Layout.SmallPadding
    
    private let viewModel: ViewModel
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    private var noInsightsView: some View {
        // Centered if we show no insights
        HStack {
            Spacer()
            Text("No insights for this ingredient.")
                .withAppStyle()
            Spacer()
        }
    }
    private var insightsView: some View {
        // Show an icon textview for each insight that we get
        // Aligned to left if we show insights
        HStack {
            VStack(alignment: .leading, spacing: IngredientInfoBodyView.InsightLinePadding) {
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
extension IngredientInfoBodyView {
    struct ViewModel {
        private let dto: AnalyzedIngredientDTO
        var showNoInsightsText: Bool { dto.insights.isEmpty }
        var insightViewModels: [AnalysisIconTextView.ViewModel] {
            var positiveInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            var cautionWarnInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            var cautionSevereInsightViewModels: [AnalysisIconTextView.ViewModel] = []
            self.dto.insights.forEach { insight in
                let vm = AnalysisIconTextView.ViewModel(
                    text: insight.code.getStringDescription(),
                    icon: insight.type.getAssociatedIcon(),
                    color: insight.type.getAssociatedColor()
                )
                switch insight.type {
                case .positive:
                    positiveInsightViewModels.append(vm)
                case .cautionWarn:
                    cautionWarnInsightViewModels.append(vm)
                case .cautionSevere:
                    cautionSevereInsightViewModels.append(vm)
                case .none:
                    AppLogging.warn("Unparseable type found for code \(insight.code.rawValue)")
                }
            }
            // Severe first, but since these are specific to one ingredient, chances are we only have one type
            return cautionSevereInsightViewModels + cautionWarnInsightViewModels + positiveInsightViewModels
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
        case .scogs3:
            return """
            This is in the FDA's GRAS (Generally Recognized as Safe) database, but there is uncertainty around its safety in scientific literature (SCOGS Conclusion 3).
            """
        case .scogs4:
            return """
            This is in the FDA's GRAS (Generally Recognized as Safe) database, but there is some scientific evidence to show that it is harmful to public health (SCOGS Conclusion 4).
            """
        case .scogs5:
            return """
            This is in the FDA's GRAS (Generally Recognized as Safe) database,but lacks scientific evidence to fully confirm its safety (SCOGS Conclusion 5).
            """
        case .unknown:
            return ""
        }
    }
}

struct IngredientInfoBodyView_Previews: PreviewProvider {
    private static let cautionWarningVm = IngredientInfoBodyView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientDextrose)
    private static let multipleWarningsVm = IngredientInfoBodyView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientMultipleInsights)
    private static let noInsightsVm = IngredientInfoBodyView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientNoInsights)
    
    static var previews: some View {
        ColorSchemePreview {
            Group {
                IngredientInfoBodyView(vm: cautionWarningVm)
                IngredientInfoBodyView(vm: multipleWarningsVm)
                IngredientInfoBodyView(vm: noInsightsVm)
            }
            .background(Color.App.BackgroundSecondaryFillColor)
            .padding()
        }
        .frame(width: 500)
        .previewLayout(.sizeThatFits)
    }
}
