//
// Created by Frank Jia on 2020-05-13.
// Copyright (c) 2020 Frank Jia. All rights reserved.
//

import Foundation
import SwiftUI

typealias Middleware<Action> = (Action) -> ()
class StateMachineViewModel<State, Action>: ObservableObject {
    // State of the current view
    @Published var state: State {
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
    func leaveState(_ state: State) {}
    func enterState(_ state: State) {}

    // Runs the defined middleware
    private func runMiddleware(_ action: Action) {
        for fn in middleware {
            fn(action)
        }
    }
}