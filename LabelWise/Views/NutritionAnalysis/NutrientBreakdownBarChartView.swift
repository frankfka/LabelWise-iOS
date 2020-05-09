//
//  NutrientBreakdownBarChartView.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-08.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct NutrientBreakdownBarChartView: View {
    private static let PlaceholderColor: Color = Color.App.PrimaryFillColor
    private static let PlaceholderValue: Value = Value(relativeWidth: 1, color: PlaceholderColor)
    private static let DefaultBarHeight: CGFloat = 36
    private static let CornerRadius: CGFloat = CGFloat.App.Layout.CornerRadius
    
    struct Value {
        let relativeWidth: Double
        let color: Color
    }
    
    private let barHeight: CGFloat
    private let values: [Value]
    
    init(values: [Value], barHeight: CGFloat = NutrientBreakdownBarChartView.DefaultBarHeight) {
        self.values = values
        self.barHeight = barHeight
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                // Bottom placeholder
                self.getRectangle(from: NutrientBreakdownBarChartView.PlaceholderValue, parentSize: geometry.size)
                // Macronutrient bars
                HStack(spacing: 0) {
                    ForEach(0..<self.values.count, id: \.self) { index in
                        self.getRectangle(from: self.values[index], parentSize: geometry.size)
                    }
                }
            }
            .frame(height: self.barHeight)
            .clipShape(RoundedRectangle(cornerRadius: NutrientBreakdownBarChartView.CornerRadius))
        }
    }
    
    
    @ViewBuilder
    private func getRectangle(from value: Value, parentSize: CGSize) -> some View {
        Rectangle()
            .frame(width: parentSize.width * value.relativeWidth.toCGFloat())
            .foregroundColor(value.color)
    }
}

struct NutrientBreakdownBarChartView_Previews: PreviewProvider {
    
    private static let values: [NutrientBreakdownBarChartView.Value] = [
        NutrientBreakdownBarChartView.Value(relativeWidth: 0.2, color: Color.App.CarbIndicator),
        NutrientBreakdownBarChartView.Value(relativeWidth: 0.3, color: Color.App.ProteinIndicator),
        NutrientBreakdownBarChartView.Value(relativeWidth: 0.1, color: Color.App.FatIndicator)
    ]
    
    static var previews: some View {
        ColorSchemePreview {
            NutrientBreakdownBarChartView(values: values)
            .padding()
        }
    }
}
