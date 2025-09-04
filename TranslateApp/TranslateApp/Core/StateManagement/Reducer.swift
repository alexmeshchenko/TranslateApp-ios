//
//  Reducer.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//
import Foundation
#if os(iOS)
import UIKit
#endif

// MARK: - Reducer Protocol
/// A pure function that takes the current state and an action, and returns a new state and optional effects
protocol Reducer {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    
    /// Reduce state based on action and return effects
    func reduce(state: inout State, action: Action) -> Effect<Action>
}

// MARK: - AnyReducer
/// Type-erased reducer wrapper
struct AnyReducer<State: Equatable, Action: Equatable>: Reducer {
    private let _reduce: (inout State, Action) -> Effect<Action>
    
    init<R: Reducer>(_ reducer: R) where R.State == State, R.Action == Action {
        self._reduce = reducer.reduce
    }
    
    init(reduce: @escaping (inout State, Action) -> Effect<Action>) {
        self._reduce = reduce
    }
    
    func reduce(state: inout State, action: Action) -> Effect<Action> {
        _reduce(&state, action)
    }
}

// MARK: - Reducer Composition
extension AnyReducer {
    /// Combine multiple reducers into one
    static func combine(_ reducers: AnyReducer...) -> AnyReducer {
        AnyReducer { state, action in
            let effects = reducers.map { $0.reduce(state: &state, action: action) }
            return .batch(effects)
        }
    }
}

// MARK: - Logging Reducer
extension AnyReducer {
    /// Add logging to any reducer
    func logging(
        actionPredicate: @escaping (Action) -> Bool = { _ in true },
        statePredicate: @escaping (State) -> Bool = { _ in true }
    ) -> AnyReducer {
        AnyReducer { state, action in
            let oldState = state
            let effect = self.reduce(state: &state, action: action)
            
            if actionPredicate(action) || statePredicate(state) {
                print("🔄 Action: \(action)")
                if statePredicate(state) && oldState != state {
                    print("📝 State changed")
                }
            }
            
            return effect
        }
    }
}
