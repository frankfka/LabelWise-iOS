
//
//  AllParsedIngredientsSectionView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-23.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

// MARK: View
struct AllParsedIngredientsSectionView: View {
    private static let VerticalSpacing: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let TextFont: Font = Font.App.NormalText
    private static let TextColor: Color = Color.App.Text
    private static let TextBackgroundVerticalPadding: CGFloat = CGFloat.App.Layout.SmallPadding
    private static let TextBackgroundHorizontalPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let NoParsedIngredientsTextPadding: CGFloat = CGFloat.App.Layout.Padding
    private static let NoParsedIngredientsTextFont: Font = Font.App.NormalText
    private static let NoParsedIngredientsTextColor: Color = Color.App.Text
    // TODO: Something like this with rounded rectangle icons?
    // https://stackoverflow.com/questions/57510093/swiftui-how-to-have-hstack-wrap-children-along-multiple-lines-like-a-collectio

    private let viewModel: ViewModel

    init(vm: ViewModel) {
        self.viewModel = vm
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AllParsedIngredientsSectionView.VerticalSpacing) {
            if self.viewModel.hasParsedIngredients {
                ForEach(0..<self.viewModel.parsedIngredients.count, id: \.self) { idx in
                    HStack {
                        Text(self.viewModel.parsedIngredients[idx])
                            .withAppStyle(
                                    font: AllParsedIngredientsSectionView.TextFont,
                                    color: AllParsedIngredientsSectionView.TextColor
                            )
                        Spacer()
                    }
                    .padding(.vertical, AllParsedIngredientsSectionView.TextBackgroundVerticalPadding)
                    .padding(.horizontal, AllParsedIngredientsSectionView.TextBackgroundHorizontalPadding)
                    .background(
                        RoundedRectangle.Standard
                            .foregroundColor(Color.App.BackgroundTertiaryFillColor)
                    )
                }
            } else {
                Text("No ingredients were parsed.")
                    .withAppStyle(
                        font: AllParsedIngredientsSectionView.NoParsedIngredientsTextFont,
                        color: AllParsedIngredientsSectionView.NoParsedIngredientsTextColor
                    )
                    .padding(AllParsedIngredientsSectionView.NoParsedIngredientsTextPadding)
            }
        }
    }
}
// MARK: View Model
extension AllParsedIngredientsSectionView {
    struct ViewModel {
        let parsedIngredients: [String]
        var hasParsedIngredients: Bool {
            !self.parsedIngredients.isEmpty
        }
        
        init(parsedIngredients: [String]) {
            self.parsedIngredients = parsedIngredients.sorted().map {
                $0.capitalized(with: .current)
            }
        }
    }
}

struct AllParsedIngredientsSectionView_Previews: PreviewProvider {
    private static let multipleParsedIngredientsVm = AllParsedIngredientsSectionView.ViewModel(
        parsedIngredients: PreviewIngredientsModels.MultipleParsedIngredients
    )
    private static let noParsedIngredientsVm = AllParsedIngredientsSectionView.ViewModel(
        parsedIngredients: []
    )
    
    static var previews: some View {
        ColorSchemePreview {
            Group {
                AllParsedIngredientsSectionView(vm: multipleParsedIngredientsVm)
                AllParsedIngredientsSectionView(vm: noParsedIngredientsVm)
            }
            .background(Color.App.BackgroundSecondaryFillColor)
            .padding()
        }.previewLayout(.sizeThatFits)
    }
}
