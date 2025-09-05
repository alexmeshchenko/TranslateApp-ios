//
//  Store.swift
//  TranslateApp
//
//  Created by Aleksandr Meshchenko on 03.09.25.
//



import Foundation
import SwiftUI
import Combine

// MARK: - Store
/// The central state container for the application
@MainActor
final class Store<State: Equatable, Action: Equatable>: ObservableObject {
    
    // MARK: - Properties
    
    /// Current state (published for SwiftUI)
    @Published private(set) var state: State
    
    /// The reducer that handles state mutations
    private let reducer: AnyReducer<State, Action>
    
    /// Manages side effects
    private let effectRunner = EffectRunner<Action>()
    
    /// Middleware functions
    private var middlewares: [(Store, Action) -> Void] = []
    
    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(
        initialState: State,
        reducer: AnyReducer<State, Action>,
        middlewares: [(Store, Action) -> Void] = []
    ) {
        self.state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    // MARK: - Public Methods
    
    /// Dispatch an action to the store
    func dispatch(_ action: Action) {
        // Run middlewares
        middlewares.forEach { middleware in
            middleware(self, action)
        }
        
        // Reduce state
        let effect = reducer.reduce(state: &state, action: action)
        
        // Run side effects
        effectRunner.run(effect) { [weak self] action in
            Task { @MainActor in
                self?.dispatch(action)
            }
        }
    }
    
    /// Create a binding for a specific value in the state
    func binding<Value>(
        get: @escaping (State) -> Value,
        send: @escaping (Value) -> Action
    ) -> Binding<Value> {
        Binding(
            get: { get(self.state) },
            set: { self.dispatch(send($0)) }
        )
    }
    
    /// Create a derived store for a subset of state
    func scope<LocalState: Equatable, LocalAction: Equatable>(
        state: @escaping (State) -> LocalState,
        action: @escaping (LocalAction) -> Action
    ) -> Store<LocalState, LocalAction> {
        // This would require more complex implementation
        // For now, keeping it simple
        fatalError("Scope not implemented yet")
    }
}

// MARK: - Convenience Store Type
typealias AppStore = Store<AppState, AppAction>

// MARK: - Store Creation Helper
extension Store where State == AppState, Action == AppAction {
    static func makeAppStore() -> AppStore {
        var initialState = AppState.initial
        
        // Сразу загружаем сохраненные настройки
        if let sourceCode = UserDefaults.standard.string(forKey: "sourceLanguage"),
           let targetCode = UserDefaults.standard.string(forKey: "targetLanguage"),
           let source = Language(rawValue: sourceCode),
           let target = Language(rawValue: targetCode) {
            initialState.sourceLanguage = source
            initialState.targetLanguage = target
            initialState.lastUsedLanguagePair = LanguagePair(source: source, target: target)
        }
        
        if let favoritesCodes = UserDefaults.standard.array(forKey: "favoriteLanguages") as? [String] {
            initialState.favoriteLanguages = Set(favoritesCodes.compactMap { Language(rawValue: $0) })
        }
        
        let reducer = AnyReducer(AppReducer()).logging()
        
        return AppStore(
            initialState: initialState,
            reducer: reducer,
            middlewares: [
                loggingMiddleware,
                analyticsMiddleware
            ]
        )
    }
}

// MARK: - Middleware Examples
private func loggingMiddleware<State, Action>(
    store: Store<State, Action>,
    action: Action
) where Action: CustomStringConvertible {
    #if DEBUG
    print("🎯 Dispatched: \(action)")
    #endif
}

private func analyticsMiddleware(
    store: AppStore,
    action: AppAction
) {
    // Track analytics events
    switch action {
    case .translate:
        print("📊 Analytics: User initiated translation")
    case .swapLanguages:
        print("📊 Analytics: User swapped languages")
    default:
        break
    }
}

// MARK: - SwiftUI Environment
struct StoreKey: EnvironmentKey {
    static let defaultValue: AppStore? = nil
}

extension EnvironmentValues {
    var store: AppStore? {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}

extension View {
    /// Inject store into environment
    func withStore(_ store: AppStore) -> some View {
        self.environment(\.store, store)
    }
}

// MARK: - Store Extensions for Testing
#if DEBUG
extension Store {
    /// Send multiple actions for testing
    func sendActions(_ actions: [Action]) {
        actions.forEach(dispatch)
    }
    
    /// Get current state for assertions
    var currentState: State {
        state
    }
    
    /// Reset store to initial state (for testing)
    func reset(to state: State) {
        self.state = state
        effectRunner.cancelAll()
    }
}
#endif
