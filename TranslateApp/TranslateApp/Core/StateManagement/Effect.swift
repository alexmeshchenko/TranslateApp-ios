//
//  Effect.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//

import Foundation
import Combine

// MARK: - Effect
/// Represents a side effect that can be executed asynchronously
struct Effect<Action> {
    let id: UUID
    let work: (@escaping (Action) -> Void) async throws -> Void
    
    init(
        id: UUID = UUID(),
        work: @escaping (@escaping (Action) -> Void) async throws -> Void
    ) {
        self.id = id
        self.work = work
    }
}

// MARK: - Effect Constructors
extension Effect {
    /// Create an empty effect (no side effects)
    static var none: Effect {
        Effect { _ in }
    }
    
    /// Create an effect that immediately dispatches an action
    static func immediate(_ action: Action) -> Effect {
        Effect { dispatch in
            dispatch(action)
        }
    }
    
    /// Create an effect with a delay
    static func delayed(_ action: Action, seconds: TimeInterval) -> Effect {
        Effect { dispatch in
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            dispatch(action)
        }
    }
    
    /// Combine multiple effects into one
    static func batch(_ effects: [Effect]) -> Effect {
        Effect { dispatch in
            await withTaskGroup(of: Void.self) { group in
                for effect in effects {
                    group.addTask {
                        try? await effect.work(dispatch)
                    }
                }
            }
        }
    }
    
    /// Create an effect from an async operation
    static func task<T>(
        operation: @escaping () async throws -> T,
        success: @escaping (T) -> Action,
        failure: @escaping (Error) -> Action
    ) -> Effect {
        Effect { dispatch in
            do {
                let result = try await operation()
                dispatch(success(result))
            } catch {
                dispatch(failure(error))
            }
        }
    }
}

// MARK: - Effect Operators
extension Effect {
    /// Map effect to different action type
    func map<NewAction>(_ transform: @escaping (Action) -> NewAction) -> Effect<NewAction> {
        Effect<NewAction> { dispatch in
            try await self.work { action in
                dispatch(transform(action))
            }
        }
    }
    
    /// Cancel effect after timeout
    func timeout(_ seconds: TimeInterval) -> Effect {
        Effect { dispatch in
            let task = Task {
                try await self.work(dispatch)
            }
            
            Task {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                task.cancel()
            }
        }
    }
    
    /// Debounce effect
    static func debounce<ID: Hashable>(
        id: ID,
        for seconds: TimeInterval,
        action: @escaping () -> Action
    ) -> Effect {
        Effect { dispatch in
            // Cancel previous task with same ID
            DebounceStorage.shared.cancel(id: id)
            
            // Create new debounced task
            let task = Task {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                guard !Task.isCancelled else { return }
                dispatch(action())
            }
            
            // Store task
            DebounceStorage.shared.store(task: task, for: id)
        }
    }
}

// MARK: - Effect Runner
/// Manages effect execution
@MainActor
final class EffectRunner<Action> {
    private var currentTasks: [UUID: Task<Void, Never>] = [:]
    
    func run(_ effect: Effect<Action>, dispatch: @escaping (Action) -> Void) {
        let task = Task {
            do {
                try await effect.work(dispatch)
            } catch {
                print("Effect error: \(error)")
            }
            currentTasks.removeValue(forKey: effect.id)
        }
        currentTasks[effect.id] = task
    }
    
    func cancelAll() {
        currentTasks.values.forEach { $0.cancel() }
        currentTasks.removeAll()
    }
    
    func cancel(id: UUID) {
        currentTasks[id]?.cancel()
        currentTasks.removeValue(forKey: id)
    }
}


// MARK: - Debounce Storage
/// Global storage for debounced tasks
final class DebounceStorage {
    static let shared = DebounceStorage()
    private var tasks = [AnyHashable: Task<Void, Never>]()
    private let queue = DispatchQueue(label: "com.translateapp.debounce")
    
    private init() {}
    
    func store(task: Task<Void, Never>, for id: AnyHashable) {
        queue.sync {
            tasks[id] = task
        }
    }
    
    func cancel(id: AnyHashable) {
        queue.sync {
            tasks[id]?.cancel()
            tasks.removeValue(forKey: id)
        }
    }
    
    func cancelAll() {
        queue.sync {
            tasks.values.forEach { $0.cancel() }
            tasks.removeAll()
        }
    }
}
