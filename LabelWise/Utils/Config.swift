//
// Created by Frank Jia on 2020-05-17.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

struct Configuration {
    static let app = try! Configuration() // TODO: error handling
    static func getValue(for key: String) throws -> String {
        if let val = Bundle.main.object(forInfoDictionaryKey: key) as? String {
            return val
        } else {
            throw AppError("Unable to get value for key \(key)")
        }
    }

    let serviceBaseUrl: String
    let apiKey: String

    init() throws {
        self.serviceBaseUrl = "https://" + (try Configuration.getValue(for: "ServiceBaseUrl"))
        self.apiKey = try Configuration.getValue(for: "APIKey")
    }
}
