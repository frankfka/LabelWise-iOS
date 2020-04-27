//
// Created by Frank Jia on 2020-04-26.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import Combine

extension Subscribers.Completion {
    func getError() -> Failure? {
        switch self {
        case .finished:
            return nil
        case let .failure(err):
            return err
        }
    }
}