//
//  MacronutrientRings.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-04-29.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct MacronutrientRings: View {
    
    @State var carbPercentage: Double = 0
    
    var body: some View {
        PercentageRing(percent: self.$carbPercentage, ringWidth: 50, backgroundColor: Color.green.opacity(0.2), foregroundColors: [.green, .blue])
    }
}

struct MacronutrientRings_Previews: PreviewProvider {
    static var previews: some View {
        MacronutrientRings()
    }
}
