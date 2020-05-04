//
//  NutritionAnalysisViewModel.swift
//  LabelWise
//
//  Created by Frank Jia on 2020-05-03.
//  Copyright © 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension NutritionAnalysisView {
    class ViewModel: ObservableObject {
        
    }
}

// Additional models for vm
extension NutritionAnalysisView.ViewModel {
    // State of the analysis view
    enum ViewState {
        case analyzing
        case error
        case displayResults
    }
}
