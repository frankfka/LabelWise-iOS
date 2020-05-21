//
//  IngredientInfoView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-19.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct TappableIngredientInfoRowView: View {
    private static let IngredientNameFont: Font = Font.App.NormalText
    private static let IngredientNameColor: Color = Color.App.Text
    private static let AssociatedIconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let ExpandIconSize: CGFloat = CGFloat.App.Icon.ExtraSmallIcon
    private static let ExpandIconColor: Color = Color.App.Text
    
    var body: some View {
        HStack() {
            Text("Dextrose")
                .withStyle(
                    font: TappableIngredientInfoRowView.IngredientNameFont,
                    color: TappableIngredientInfoRowView.IngredientNameColor
            )
            Spacer()
            Image.App.ExclamationMarkCircle
                .resizable()
                .frame(width: TappableIngredientInfoRowView.AssociatedIconSize, height: TappableIngredientInfoRowView.AssociatedIconSize)
                .foregroundColor(Color.App.AppGreen)
            Image.App.RightChevron
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: TappableIngredientInfoRowView.ExpandIconSize,
                    height: TappableIngredientInfoRowView.ExpandIconSize
            )
                .foregroundColor(TappableIngredientInfoRowView.ExpandIconColor)
            //                .rotationEffect(.degrees(self.isExpanded.wrappedValue ? 90 : 0))
            //                .animation(.easeOut(duration: ShowHideNutritionButtonView.AnimationDuration))
        }.padding(CGFloat.App.Layout.Padding)
    }
}

struct IngredientInfoView: View {
    var body: some View {
        VStack(spacing: 0) {
            TappableIngredientInfoRowView()
            VStack {
                Divider().padding(.horizontal)
                Text("hello")
                    .frame(height: 200)
            }
        }
        .background(
            RoundedRectangle.Standard
                .foregroundColor(Color.App.BackgroundTertiaryFillColor)
        )
    }
}

struct IngredientInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview {
            VStack() {
                IngredientInfoView()
                IngredientInfoView()
                IngredientInfoView()
            }
            .modifier(AnalysisSectionModifier())
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
