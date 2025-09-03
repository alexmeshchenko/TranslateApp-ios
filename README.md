# TranslateApp iOS 🌍

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-Redux--like-green.svg)](https://redux.js.org/understanding/thinking-in-redux/motivation)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

A modern iOS translation application built with SwiftUI, featuring a custom Redux-like unidirectional data flow architecture. This educational project demonstrates state management patterns, API integration, and Swift 6 modern concurrency features.
<!--
## 📱 Screenshots

<p align="center">
  <img src="docs/images/screenshot1.png" width="250" alt="Main Screen"/>
  <img src="docs/images/screenshot2.png" width="250" alt="Language Selection"/>
  <img src="docs/images/screenshot3.png" width="250" alt="Translation Result"/>
</p>
-->

## ✨ Features

### Core Functionality
- 🔤 **Text Translation** - Translate text between multiple languages
- 🔄 **Language Swap** - Quick swap between source and target languages
- 📋 **Copy Translation** - One-tap copy translated text to clipboard
- 🗑️ **Clear Text** - Quick clear input and output fields
<!-- - 🌐 **Multi-language Support** - Support for 10+ languages -->

### Advanced Features
- ⚡ **Real-time Translation** - Instant translation as you type (with debouncing)
- 🎯 **Smart Language Detection** - Auto-detect source language
<!--
- 📱 **Responsive Design** - Optimized for all iOS devices
- 🌙 **Dark Mode** - Full dark mode support
- ♿ **Accessibility** - VoiceOver and Dynamic Type support
-->

## 🏗️ Architecture

This project implements a **Redux-like Unidirectional Data Flow** architecture with the following principles:

### Core Concepts
```mermaid
graph TD
    A[View<br/>SwiftUI Views & Modifiers] -->|User Action| B[Store<br/>Single Source of Truth]
    B -->|Dispatch| C[Reducer<br/>Pure Function]
    C -->|New State| D[State<br/>Immutable Data]
    D -->|Updates| E[View Rerenders]
    E -->|Observable| A
    
    style A fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style B fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style C fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style D fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style E fill:#fce4ec,stroke:#880e4f,stroke-width:2px
```

### Alternative circular flow representation:
```mermaid
flowchart LR
    View((View)) --> |1. User Action| Store{Store}
    Store --> |2. Dispatch Action| Reducer[Reducer]
    Reducer --> |3. Calculate New State| State[(State)]
    State --> |4. Notify Changes| View
    
    style View fill:#bbdefb
    style Store fill:#ffccbc
    style Reducer fill:#d1c4e9
    style State fill:#c8e6c9
```

### Key Components

#### 1. **State**
Single immutable source of truth for the entire application
```swift
struct AppState: Equatable {
    var sourceText: String
    var translatedText: String
    var sourceLanguage: Language
    var targetLanguage: Language
    var isLoading: Bool
    var error: TranslationError?
}
```

#### 2. **Actions**
Describe intentions to change state
```swift
enum AppAction {
    case textEntered(String)
    case translate
    case translationReceived(Result<String, Error>)
    case swapLanguages
}
```

#### 3. **Reducer**
Pure function that computes new state
```swift
func appReducer(state: inout AppState, action: AppAction) -> Effect<AppAction>
```

#### 4. **Effects**
Handle side effects like API calls
```swift
struct Effect<Action> {
    let run: (@escaping (Action) -> Void) async -> Void
}
```

## 🛠️ Tech Stack

- **UI Framework**: SwiftUI
- **Architecture**: Custom Redux/Unidirectional Data Flow
- **Language**: Swift 6.0
- **Minimum iOS**: 18.0
- **Concurrency**: Swift Structured Concurrency (async/await)
- **Networking**: URLSession with async/await
- **API**: [FTApi Translation Service](https://ftapi.pythonanywhere.com/)
- **Testing**: XCTest + Swift Testing framework
- **Storage**: UserDefaults for preferences


## High-level architectural module diagram

```mermaid
graph TD
    App[App Layer<br/>Entry Point & Config] --> Core
    App --> Features
    
    Core[Core Layer<br/>Redux, Models, Extensions] --> Redux[Redux<br/>Store, Reducer, Effects]
    Core --> Models[Models<br/>Domain Models]
    Core --> Extensions[Extensions<br/>Helpers]
    
    Features[Features Layer<br/>Business Logic] --> Translation[Translation<br/>State, Views, Effects]
    Features --> Settings[Settings<br/>State, Views]
    
    Translation --> Services
    Settings --> Services
    
    Services[Services Layer<br/>External Dependencies] --> API[API<br/>Network Layer]
    Services --> Storage[Storage<br/>Persistence]
    Services --> Audio[Audio<br/>TTS Service]
    
    Tests[Tests<br/>Unit & UI Tests] -.->|Tests| Core
    Tests -.->|Tests| Features
    Tests -.->|Tests| Services
    
    style App fill:#e3f2fd
    style Core fill:#fff3e0
    style Features fill:#f3e5f5
    style Services fill:#e8f5e9
    style Tests fill:#ffebee
```

## modular dependency diagram

```mermaid
graph LR
    subgraph Presentation
        View[SwiftUI Views]
    end
    
    subgraph Business
        State[State Management]
        Reducer[Reducers]
        Effects[Effects]
    end
    
    subgraph Infrastructure
        API[API Service]
        Storage[Storage]
        Audio[Audio Service]
    end
    
    View --> State
    State --> Reducer
    Reducer --> Effects
    Effects --> API
    Effects --> Storage
    View --> Audio
```

<!--
## 📂 Project Structure

```
TranslateApp-ios/
├── App/
│   ├── TranslateApp.swift              # App entry point
│   └── Configuration/                   # App configuration
│       └── AppConfig.swift
├── Core/
│   ├── StateManagement/                # Unidirectional data flow (Redux implementation)
│   │   ├── Store.swift                 # @MainActor Store class
│   │   ├── Reducer.swift               # Reducer protocol
│   │   ├── Effect.swift                # Effects system
│   │   └── Middleware.swift            # Middleware support
│   ├── Models/
│   │   ├── Language.swift              # Language model
│   │   ├── Translation.swift           # Translation models
│   │   └── TranslationError.swift     # Error types
│   └── Extensions/
│       ├── View+Extensions.swift
│       └── String+Extensions.swift
├── Features/
│   ├── Translation/
│   │   ├── State/
│   │   │   ├── TranslationState.swift
│   │   │   └── TranslationAction.swift
│   │   ├── Views/
│   │   │   ├── TranslationView.swift
│   │   │   ├── TextInputView.swift
│   │   │   └── LanguagePickerView.swift
│   │   ├── Reducers/
│   │   │   └── TranslationReducer.swift
│   │   └── Effects/
│   │       └── TranslationEffects.swift
│   └── Settings/
│       ├── Views/
│       │   └── SettingsView.swift
│       └── State/
│           └── SettingsState.swift
├── Services/
│   ├── API/
│   │   ├── TranslationService.swift    # API client
│   │   ├── APIEndpoint.swift           # Endpoints enum
│   │   └── NetworkError.swift          # Network errors
│   ├── Storage/
│   │   └── UserDefaultsService.swift
│   └── Audio/
│       └── TextToSpeechService.swift
├── Resources/
│   ├── Assets.xcassets
│   ├── Localizable.strings
│   └── Info.plist
└── Tests/
    ├── UnitTests/
    │   ├── Redux/
    │   │   ├── StoreTests.swift
    │   │   └── ReducerTests.swift
    │   ├── Services/
    │   │   └── TranslationServiceTests.swift
    │   └── Mocks/
    │       └── MockTranslationService.swift
    └── UITests/
        └── TranslationFlowTests.swift
```
-->
## 🚀 Getting Started

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 18.0+ deployment target
- Active internet connection for API calls

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/alexmeshchenko/TranslateApp-ios.git
cd TranslateApp-ios
```

2. **Open in Xcode**
```bash
open TranslateApp.xcodeproj
```

3. **Build and Run**
- Select your target device or simulator
- Press `Cmd + R` to build and run
- Alternatively, use `Cmd + U` to run tests

### Configuration

No additional configuration required. The app uses the public translation API without authentication.

## 🔌 API Reference

### Base URL
```
https://ftapi.pythonanywhere.com
```

### Endpoints

#### Translate Text
```http
POST /translate
Content-Type: application/json

Request:
{
  "text": "Hello world",
  "source_lang": "en",
  "target_lang": "es"
}

Response:
{
  "translated_text": "Hola mundo",
  "source_lang": "en",
  "target_lang": "es"
}
```

#### Get Supported Languages
```http
GET /languages

Response:
{
  "languages": [
    {"code": "en", "name": "English"},
    {"code": "es", "name": "Spanish"},
    {"code": "fr", "name": "French"}
  ]
}
```

## 🧪 Testing

### Run All Tests
```bash
xcodebuild test -scheme TranslateApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage
The project maintains:
- **70%+** coverage for business logic
- **50%+** coverage for UI components
- **90%+** coverage for Redux reducers

### Testing Strategy
- **Unit Tests**: Reducers, Services, Models
- **Integration Tests**: API calls, Redux flow
- **UI Tests**: Critical user paths

## 📱 Requirements

### Functional Requirements

#### ✅ Basic Level
- [ ] **Text Fields**
  - [ ] Input text field for source text
  - [ ] Output text field for translated text (read-only)
- [ ] **Input Processing**
  - [ ] Handle text input events
  - [ ] Validate input (empty, max length)
- [ ] **API Integration**
  - [ ] Connect to translation API
  - [ ] Process response and display translated text
- [ ] **Language Management**
  - [ ] Implement language switching UI
  - [ ] Quick swap languages button
- [ ] **Utility Features**
  - [ ] Clear text button
  - [ ] Copy translated text functionality

#### 🚀 Advanced Level
- [ ] **Animations**
  - [ ] Loading effect during translation request
  - [ ] Smooth transitions between states
- [ ] **Audio**
  - [ ] Text-to-speech for source text
  - [ ] Text-to-speech for translated text
- [ ] **Preferences**
  - [ ] Auto-save last selected language pair
  - [ ] Restore language selection on app launch
- [ ] **Favorite Languages**
  - [ ] Mark languages with star for quick access
  - [ ] Prioritize favorite languages in picker

### Non-Functional Requirements
- **Performance**: Translation response < 2 seconds
- **Reliability**: 99% uptime during normal operation
- **Usability**: Intuitive UI following iOS HIG
- **Accessibility**: Full VoiceOver support
- **Localization**: Support for system language

## 🎨 Design Guidelines

### UI/UX Principles
- **Clarity**: Clear visual hierarchy
- **Deference**: Content-first approach
- **Depth**: Subtle layering and animations
- **Consistency**: Following iOS Human Interface Guidelines

### Color Scheme
- Primary: System Blue
- Background: System Background
- Text: Label colors (adaptive)
- Accent: Tint colors for actions

## 🔧 Development

### Code Style
- Follow [Swift Style Guide](https://google.github.io/swift/)
- Use SwiftLint for code consistency
- Prefer composition over inheritance
- Keep views small and focused

### Git Flow
```
main
  └── develop
        ├── feature/translation-ui
        ├── feature/redux-setup
        └── bugfix/api-error-handling
```

### Commit Convention
```
<type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore
Example: feat(translation): add language swap animation
```

## 🤝 Contributing

This is an educational project, but feedback and suggestions are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- SwiftUI Marathon organizers for the challenge
- [FTApi](https://ftapi.pythonanywhere.com) for providing the translation API
- Apple Developer Documentation for SwiftUI resources

## 📞 Contact

Alex Meshchenko - [@alexmeshchenko](https://github.com/alexmeshchenko)

Project Link: [https://github.com/alexmeshchenko/TranslateApp-ios](https://github.com/alexmeshchenko/TranslateApp-ios)

---

<p align="center">Made with ❤️ using SwiftUI and Redux</p>
<p align="center">
  <a href="#translateapp-ios-">Back to top ↑</a>
</p>
