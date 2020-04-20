//
// Created by Frank Jia on 2020-04-18.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import SwiftUI

struct LabelScannerView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            CameraView()
            LabelScannerOverlayView()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct LabelScannerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelScannerView()
    }
}
