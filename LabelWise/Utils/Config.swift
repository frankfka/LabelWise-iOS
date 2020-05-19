//
// Created by Frank Jia on 2020-05-17.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

protocol Configuration {
    var serviceBaseUrl: String { get }
    var apiKey: String { get }
}

struct AppConfiguration: Configuration {
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
        self.serviceBaseUrl = "https://" + (try AppConfiguration.getValue(for: "ServiceBaseUrl"))
        self.apiKey = try AppConfiguration.getValue(for: "APIKey")
    }
}
