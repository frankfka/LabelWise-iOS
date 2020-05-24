//
// Created by Frank Jia on 2020-05-20.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct AnalyzedIngredientSummaryRowView: View {
    private static let IngredientNameFont: Font = Font.App.NormalText
    private static let IngredientNameColor: Color = Color.App.Text
    private static let AssociatedIconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let ExpandIconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let ExpandIconColor: Color = Color.App.SecondaryText
    private static let ExpansionAnimationDuration: Double = 0.2

    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        HStack() {
            Text(self.viewModel.name)
                .withAppStyle(
                    font: AnalyzedIngredientSummaryRowView.IngredientNameFont,
                    color: AnalyzedIngredientSummaryRowView.IngredientNameColor
                )
            Spacer()
            // Associated icon for the ingredient
            self.viewModel.icon
                .resizable()
                .frame(width: AnalyzedIngredientSummaryRowView.AssociatedIconSize, height: AnalyzedIngredientSummaryRowView.AssociatedIconSize)
                .foregroundColor(self.viewModel.iconColor)
            // Expand/shrink icon
            Image.App.RightChevron
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: AnalyzedIngredientSummaryRowView.ExpandIconSize,
                    height: AnalyzedIngredientSummaryRowView.ExpandIconSize
                )
                .foregroundColor(AnalyzedIngredientSummaryRowView.ExpandIconColor)
                .rotationEffect(.degrees(self.viewModel.isExpandedBinding.wrappedValue ? 90 : 0))
                .animation(.easeOut(duration: AnalyzedIngredientSummaryRowView.ExpansionAnimationDuration))
        }
    }
}

// MARK: View model
extension AnalyzedIngredientSummaryRowView {
    struct ViewModel {
        let name: String
        let icon: Image
        let iconColor: Color
        let isExpandedBinding: Binding<Bool>

        init(dto: AnalyzedIngredientDTO, isExpandedBinding: Binding<Bool>) {
            self.name = dto.name.capitalized
            self.isExpandedBinding = isExpandedBinding
            var icon = Image.App.CheckmarkCircle
            var color = Color.App.AppGreen
            for insight in dto.insights {
                if insight.type == .severeWarning {
                    icon = Image.App.XMarkCircle
                    color = Color.App.AppRed
                    break
                } else if insight.type == .cautionWarning {
                    icon = Image.App.ExclamationMarkCircle
                    color = Color.App.AppYellow
                }
            }
            self.icon = icon
            self.iconColor = color
        }
    }
}

struct AnalyzedIngredientSummaryRowView_Previews: PreviewProvider {
    private static let cautionWarningVm = AnalyzedIngredientSummaryRowView.ViewModel(
        dto: PreviewIngredientsModels.AnalyzedIngredientDextrose,
        isExpandedBinding: .constant(false)
    )

    static var previews: some View {
        ColorSchemePreview {
            AnalyzedIngredientSummaryRowView(vm: cautionWarningVm)
                .padding()
                .background(Color.App.BackgroundTertiaryFillColor)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
