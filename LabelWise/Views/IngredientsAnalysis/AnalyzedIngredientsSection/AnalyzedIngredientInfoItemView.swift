//
//  IngredientInfoItemView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-21.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct AnalyzedIngredientInfoItemView: View {
    private static let DividerPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let SectionInsetPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let Background: some View = {
        RoundedRectangle.Standard
                .foregroundColor(Color.App.BackgroundTertiaryFillColor)
    }()
    
    struct ViewModel {
        let dto: AnalyzedIngredientDTO
    }
    
    private let viewModel: ViewModel
    
    @State var isExpanded: Bool = false
    private var summaryVm: AnalyzedIngredientSummaryRowView.ViewModel {
        AnalyzedIngredientSummaryRowView.ViewModel(dto: self.viewModel.dto, isExpandedBinding: self.$isExpanded)
    }
    private var bodyVm: AnalyzedIngredientInfoBodyView.ViewModel {
        AnalyzedIngredientInfoBodyView.ViewModel(dto: self.viewModel.dto)
    }
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Always shown - tappable to expand
            AnalyzedIngredientSummaryRowView(vm: self.summaryVm)
            if self.isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.vertical, AnalyzedIngredientInfoItemView.DividerPadding)
                    AnalyzedIngredientInfoBodyView(vm: self.bodyVm)
                }
            }
        }
        .padding(AnalyzedIngredientInfoItemView.SectionInsetPadding)
        .background(AnalyzedIngredientInfoItemView.Background)
    }
}

struct AnalyzedIngredientInfoItemView_Previews: PreviewProvider {
    private static let cautionWarningVm = AnalyzedIngredientInfoItemView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientDextrose)

    static var previews: some View {
        ColorSchemePreview {
            AnalyzedIngredientInfoItemView(vm: cautionWarningVm)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
