//
// Created by Frank Jia on 2020-04-22.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct LabelImage {
    let compressedImgData: Data
    let uiImage: UIImage

    init?(fileData: Data) {
        guard let uiImage = UIImage(data: fileData) else {
            AppLogging.warn("Unable to create UI image")
            return nil
        }
        guard let compressedImage = uiImage.jpegData(compressionQuality: 0.25) else {
            AppLogging.warn("Unable to compress image")
            return nil
        }
        self.compressedImgData = compressedImage
        self.uiImage = uiImage
    }
}

// Converts captured photo to our native image type
extension AVCapturePhoto {
    func toLabelImage() -> (LabelImage?, AppError?) {
        guard let data = self.fileDataRepresentation() else {
            return (nil, AppError("Captured image has no file data representation"))
        }
        guard let labelImage = LabelImage(fileData: data) else {
            return (nil, AppError("Could not create label image from data"))
        }
        return (labelImage, nil)
    }
}
