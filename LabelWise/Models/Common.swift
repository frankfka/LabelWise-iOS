//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct AppError: Error {
    let message: String
    let wrappedError: Error?

    init(_ msg: String, wrappedError: Error? = nil) {
        self.message = msg
        self.wrappedError = wrappedError
    }
}