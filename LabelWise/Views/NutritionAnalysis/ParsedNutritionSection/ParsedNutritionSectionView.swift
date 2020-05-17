//
//  ParsedNutritionSectionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-17.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct ShowHideNutritionButtonView: View {
    private static let ContentSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let ButtonFont: Font = Font.App.NormalText
    private static let ButtonContentColor: Color = Color.App.Text
    private static let IconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let AnimationDuration: Double = 0.2
    
    private let isExpanded: Binding<Bool>
    
    init(isExpanded: Binding<Bool>) {
        self.isExpanded = isExpanded
    }
    
    var body: some View {
        Button(action: self.onTap) {
            HStack(spacing: ShowHideNutritionButtonView.ContentSpacing) {
                Text(self.isExpanded.wrappedValue ? "Hide Nutritional Info" : "Show Nutritional Info")
                    .withStyle(
                        font: ShowHideNutritionButtonView.ButtonFont,
                        color: ShowHideNutritionButtonView.ButtonContentColor
                    )
                Image.App.RightChevron
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: ShowHideNutritionButtonView.IconSize,
                        height: ShowHideNutritionButtonView.IconSize
                    )
                    .foregroundColor(ShowHideNutritionButtonView.ButtonContentColor)
                    .rotationEffect(.degrees(self.isExpanded.wrappedValue ? 90 : 0))
                    .animation(.easeOut(duration: ShowHideNutritionButtonView.AnimationDuration))
            }
        }
    }
    
    private func onTap() {
        self.isExpanded.wrappedValue.toggle()
    }
    
}
struct ParsedNutritionSectionView: View {
    
    @State var isExpanded: Bool = false
    private let viewModel: ViewModel
    
    private var tableViewVm: NutritionTableView.ViewModel {
        NutritionTableView.ViewModel(nutrition: self.viewModel.nutrition)
    }
    
    init(vm: ViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        VStack {
            ShowHideNutritionButtonView(isExpanded: self.$isExpanded)
            if self.isExpanded {
                NutritionTableView(vm: self.tableViewVm)
            }
        }.fillWidth()
    }
}
// MARK: View Model
extension ParsedNutritionSectionView {
    struct ViewModel {
        let nutrition: Nutrition
        
        init(nutrition: Nutrition) {
            self.nutrition = nutrition
        }
    }
}

struct ParsedNutritionSectionView_Previews: PreviewProvider {
    
    private static let fullyParsedVm = ParsedNutritionSectionView.ViewModel(nutrition: PreviewNutritionModels.FullyParsedNutrition)
    
    static var previews: some View {
        ColorSchemePreview {
            ParsedNutritionSectionView(vm: fullyParsedVm)
            .padding()
            .background(Color.App.BackgroundSecondaryFillColor)
        }.previewLayout(.sizeThatFits)
    }
}
