//
//  IngredientInfoItemView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-21.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct IngredientInfoItemView: View {
    private static let DividerPadding: CGFloat = CGFloat.App.Layout.Padding
    
    struct ViewModel {
        let dto: AnalyzedIngredientDTO
    }
    
    private let viewModel: ViewModel
    
    @State var isExpanded: Bool = false
    private var summaryVm: IngredientSummaryRowView.ViewModel {
        IngredientSummaryRowView.ViewModel(dto: self.viewModel.dto, isExpandedBinding: self.$isExpanded)
    }
    private var bodyVm: IngredientInfoBodyView.ViewModel {
        IngredientInfoBodyView.ViewModel(dto: self.viewModel.dto)
    }
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Always shown - tappable to expand
            IngredientSummaryRowView(vm: self.summaryVm)
            if self.isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.vertical, IngredientInfoItemView.DividerPadding)
                    IngredientInfoBodyView(vm: self.bodyVm)
                }
            }
        }.modifier(AnalysisSectionModifier())
    }
}

struct IngredientInfoItemView_Previews: PreviewProvider {
    private static let cautionWarningVm = IngredientInfoItemView.ViewModel(dto: PreviewIngredientsModels.AnalyzedIngredientDextrose)
    
    
    static var previews: some View {
        ColorSchemePreview {
            IngredientInfoItemView(vm: cautionWarningVm)
                .padding()
                .background(Color.App.BackgroundPrimaryFillColor)
        }
        .previewLayout(.sizeThatFits)
    }
}
