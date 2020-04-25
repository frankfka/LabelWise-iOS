//
// Created by Frank Jia on 2020-04-22.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct LabelImage {
    let fileData: Data
    var base64String: String {
        fileData.base64EncodedString(options: .lineLength64Characters)
    }
    // TODO: need to compress
    
    init(fileData: Data) {
        self.fileData = fileData
    }
}

// Converts captured photo to our native image type
extension AVCapturePhoto {
    func toLabelImage() -> (LabelImage?, AppError?) {
        guard let data = self.fileDataRepresentation() else {
            return (nil, AppError("Captured image has no file data representation"))
        }
        return (LabelImage(fileData: data), nil)
    }
}
