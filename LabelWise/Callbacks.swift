//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

typealias ErrorCallback = (AppError?) -> Void
typealias VoidCallback = () -> Void
typealias BoolCallback = (Bool) -> Void

typealias PhotoCaptureCallback = (LabelPhoto?, AppError?) -> Void