//
// Created by Frank Jia on 2020-04-24.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct AppLogging {
    static func debug(_ msg: String) {
        print("DEBUG: \(msg)")
    }
    static func info(_ msg: String) {
        print("INFO: \(msg)")
    }
    static func warn(_ msg: String) {
        print("WARN: \(msg)")
    }
    static func error(_ msg: String) {
        print("ERR: \(msg)")
    }
}