//
// Created by Frank Jia on 2020-04-22.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct LabelPhoto {
    let fileData: Data
    var base64String: String {
        fileData.base64EncodedString(options: .lineLength64Characters)
    }
}

// Converts captured photo to our native image type
extension AVCapturePhoto {
    func toLabelPhoto() -> LabelPhoto? {
        guard let data = self.fileDataRepresentation() else {
            // TODO: Logging
            return nil
        }
        return LabelPhoto(fileData: data)
    }
}