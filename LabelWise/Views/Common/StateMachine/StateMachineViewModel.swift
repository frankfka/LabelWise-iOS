//
// Created by Frank Jia on 2020-05-13.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

typealias Middleware<Action> = (Action) -> ()
/**
To conform, override the following:
- var middleware
- func nextState(for action: Action) -> State?
**/
class StateMachineViewModel<State, Action> {
    // State of the current view
    var state: State {
        willSet { leaveState(state) } // Leaving current state
        didSet { enterState(state) } // Entering new state
    }
    // Middleware to run before entering next state
    var middleware: [Middleware<Action>] = []

    init(state: State) {
        self.state = state
    }

    // Default dispatch - runs middleware then transitions to next state
    final func send(_ action: Action) {
        runMiddleware(action)
        if let state = nextState(for: action) {
            self.state = state
        }
    }

    // Determines next state, depending on the current action
    func nextState(for action: Action) -> State? { nil }

    // Called when leaving/entering a given state - override these to have stateful side effects
    func leaveState(_ state: State) {
        AppLogging.debug("Leaving state \(StateMachineViewModel<State, Action>.getName(state))")
    }
    func enterState(_ state: State) {
        AppLogging.debug("Entering state \(StateMachineViewModel<State, Action>.getName(state))")
    }

    // Runs the defined middleware
    private func runMiddleware(_ action: Action) {
        for fn in middleware {
            fn(action)
        }
    }
}