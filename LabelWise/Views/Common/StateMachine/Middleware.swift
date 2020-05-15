//
// Created by Frank Jia on 2020-05-13.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation

typealias ActionToWrappedErrorFunction<Action> = (Action) -> AppError?
struct AppMiddleware {
    // Function to create logging middleware for a given type of State and Action
    // Provide `getErr` to have optional error logging by returning an error from the callback
    static func getLoggingMiddleware<State, Action>(state: State,
                                                    getErr: ActionToWrappedErrorFunction<Action>?) -> Middleware<Action> {
        { action in
            AppLogging.debug("State \(StateMachineViewModel<State,Action>.getName(state)) - Dispatching \(StateMachineViewModel<State,Action>.getName(action))")
            if let getErr = getErr, let err = getErr(action) {
                AppLogging.error("Error Action : \(err)")
            }
        }
    }
}
extension StateMachineViewModel {
    // Returns the name of the action and state
    static func getName<T>(_ item: T) -> String {
        Mirror(reflecting: item).children.first?.label ?? String(describing: item)
    }
}