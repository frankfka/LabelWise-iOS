//
// Created by Frank Jia on 2020-04-19.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: Callbacks
typealias ErrorCallback = (AppError?) -> Void
typealias VoidCallback = () -> Void
typealias BoolCallback = (Bool) -> Void

typealias PhotoCaptureCallback = (LabelImage?, AppError?) -> Void

// MARK: Combine
typealias ServiceCallback<SuccessType> = (Result<SuccessType, AppError>) -> ()
typealias ServicePublisher<SuccessType> = AnyPublisher<SuccessType, AppError>
typealias ServiceFuture<SuccessType> = Future<SuccessType, AppError>

// MARK: SwiftUI
typealias ContentGenerator<Content: View> = () -> Content