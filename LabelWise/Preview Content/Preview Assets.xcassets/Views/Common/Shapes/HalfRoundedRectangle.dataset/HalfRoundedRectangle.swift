//
//  InvertedRoundedRectangleShape.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-02.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct HalfRoundedRectangle: Shape {
    private let cornerRadius: CGFloat

    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        // Constrain corner radius to size of the rectangle
        let radius = min(min(self.cornerRadius, width/2), height/2)
        
        // Inner top left
        path.move(to: CGPoint(x: radius, y: 0))
        // Outer top left
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(-180),
            clockwise: true
        )
        // Bottom left
        path.addLine(to: CGPoint(x: 0, y: height))
        // Bottom right
        path.addLine(to: CGPoint(x: width, y: height))
        // Outer top right
        path.addLine(to: CGPoint(x: width, y: radius))
        // Inner top right
        path.addArc(
            center: CGPoint(x: width - radius, y: radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )
        // Back to inner top left
        path.addLine(to: CGPoint(x: radius, y: 0))
        
        return path
    }
}

struct HalfRoundedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        HalfRoundedRectangle(cornerRadius: 24)
            .stroke()
            .fill(Color.black)
            .frame(width: 200, height: 200)
            .padding()
            .previewLayout(.sizeThatFits)
        
    }
}
