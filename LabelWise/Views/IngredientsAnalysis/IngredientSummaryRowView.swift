//
// Created by Frank Jia on 2020-05-20.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct IngredientSummaryRowView: View {
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
                    font: IngredientSummaryRowView.IngredientNameFont,
                    color: IngredientSummaryRowView.IngredientNameColor
                )
            Spacer()
            // Associated icon for the ingredient
            self.viewModel.icon
                .resizable()
                .frame(width: IngredientSummaryRowView.AssociatedIconSize, height: IngredientSummaryRowView.AssociatedIconSize)
                .foregroundColor(self.viewModel.iconColor)
            // Expand/shrink icon
            Image.App.RightChevron
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: IngredientSummaryRowView.ExpandIconSize,
                    height: IngredientSummaryRowView.ExpandIconSize
                )
                .foregroundColor(IngredientSummaryRowView.ExpandIconColor)
                .rotationEffect(.degrees(self.viewModel.isExpandedBinding.wrappedValue ? 90 : 0))
                .animation(.easeOut(duration: IngredientSummaryRowView.ExpansionAnimationDuration))
        }
    }
}

// MARK: View model
extension IngredientSummaryRowView {
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
                if insight.type == .cautionSevere {
                    icon = Image.App.XMarkCircle
                    color = Color.App.AppRed
                    break
                } else if insight.type == .cautionWarn {
                    icon = Image.App.ExclamationMarkCircle
                    color = Color.App.AppYellow
                }
            }
            self.icon = icon
            self.iconColor = color
        }
    }
}

struct IngredientSummaryRowView_Previews: PreviewProvider {
    private static let cautionWarningVm = IngredientSummaryRowView.ViewModel(
        dto: PreviewIngredientsModels.AnalyzedIngredientDextrose,
        isExpandedBinding: .constant(false)
    )

    static var previews: some View {
        ColorSchemePreview {
            IngredientSummaryRowView(vm: cautionWarningVm)
                .padding()
                .background(Color.App.BackgroundTertiaryFillColor)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
