# Router

A type-safe, lightweight, and elegant navigation routing solution for SwiftUI applications.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017+-lightgrey.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

<img width="803" height="210" alt="router-logo" src="https://github.com/user-attachments/assets/f0e07c50-e957-4b72-b79c-2dee560d5826" />

## Overview

Router simplifies navigation in SwiftUI by providing a centralized, type-safe routing system that eliminates boilerplate code and makes navigation logic clear and maintainable. 
Instead of managing multiple `@State` bindings and navigation presentation logic throughout your views, Router provides a single source of truth for all navigation events.

## The Problem

Traditional SwiftUI navigation often leads to:

- **Scattered State Management**: Navigation state spread across multiple `@State` properties
- **Complex Binding Logic**: Manually managing presentation bindings for sheets, alerts, and navigation destinations
- **Type Safety Issues**: String-based or loosely-typed routing prone to runtime errors
- **Boilerplate Code**: Repetitive presentation logic duplicated across views
- **Sequential Presentation Bugs**: Issues when presenting multiple alerts or sheets in sequence

It's surprising that Apple hasn't addressed these obvious presentation issues with a built-in single source of truth for navigation. 
Router fills this gap as the missing piece of the SwiftUI ecosystem.

## Features

✨ **Type-Safe Routing** - Define routes as strongly-typed enums or structs conforming to `Routable`

🎯 **Single Source of Truth** - One `Router` instance manages all navigation state

🔄 **Multiple Presentation Types** - Support for:
- NavigationStack destinations
- Tabs
- Sheets
- Full-screen covers
- Alerts
- Confirmation dialogs
- Custom presentations

## Installation

### Swift Package Manager

Add Router to your project using Xcode:

1. File > Add Package Dependencies
2. Enter the package URL: `https://github.com/claustrofob/Router.git`
3. Select your version requirements

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/claustrofob/Router.git", from: "1.0.0")
]
```

## Quick Start
### 1. Define Your Routes

Create routes as enums or structs conforming to `Routable`:

```swift
import Router

enum AppRoute: String, Routable {
    var id: String { rawValue }
    
    case profile
    case settings
    case about
}
```

### 2. Create a Router

Initialize a `Router` instance in your view:

```swift
import SwiftUI
import Router

struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        // Your view content
    }
}
```

### 3. Attach Route Handlers

Use the `.route()` modifier to handle navigation:

```swift
var body: some View {
    NavigationStack {
        Button("Go to Profile") {
            router.show(AppRoute.profile)
        }
        .route(AppRoute.self, in: router, presentationType: .navigationStack) { route in
            switch route {
            case .profile:
                ProfileView()
            case .settings:
                SettingsView()
            case .about:
                AboutView()
            }
        }
    }
}
```

> [!IMPORTANT]
> One `Router` instance is designed to manage navigation for **one screen**. Do not pass the same `Router` instance across different screens in your app. Each screen should have its own `Router`. However, you can freely share a `Router` instance among subviews within the same screen using `@Environment` or direct property passing.

## Usage Examples

### Navigation Stack

Navigate between views in a navigation hierarchy:

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        NavigationStack {
            List {
                Button("View Details") {
                    router.show(DetailRoute(id: "123"))
                }
            }
            .navigationTitle("Home")
            .route(DetailRoute.self, in: router, presentationType: .navigationStack) { route in
                DetailView(id: route.id)
            }
        }
    }
}

struct DetailRoute: Routable {
    var id: String
}
```

### Sheet Presentation

Present content as a sheet:

```swift
struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        Button("Show Settings") {
            router.show(SettingsRoute())
        }
        .route(SettingsRoute.self, in: router, presentationType: .sheet) { _ in
            SettingsView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct SettingsRoute: Routable {
    var id: String { "settings" }
}
```

### Alerts with Actions

Display alerts with type-safe message handling:

```swift
struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        Button("Show Alert") {
            router.show(AlertRoute(message: "Are you sure?"))
        }
        .alertRoute(
            AlertRoute.self,
            in: router,
            actionsContent: { _ in
                Button("Confirm", role: .destructive) {
                    // Handle confirmation
                    router.dismiss()
                }
                Button("Cancel", role: .cancel) {
                    router.dismiss()
                }
            }
        )
    }
}

struct AlertRoute: Routable, MessageAwareProtocol {
    var id: String { message }
    let message: String
}
```

### Confirmation Dialogs

Show action sheets with multiple options:

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        Button("Choose City") {
            router.show(CountrySelectionRoute())
        }
        .alertRoute(
            CountrySelectionRoute.self,
            in: router,
            presentationType: .confirmation,
            actionsContent: { _ in
                ForEach(Country.allCases, id: \.self) { country in
                    Button(country.rawValue) {
                        router.show(AlertRoute(message: "You chose \(country.rawValue)"))
                    }
                }
            }
        )
        .alertRoute(
            AlertRoute.self,
            in: router
        )
    }
}

struct CountrySelectionRoute: Routable, MessageAwareProtocol {
    var id: String { "countrySelection" }
    var message: String { "Choose your destination:" }
}

struct AlertRoute: Routable, MessageAwareProtocol {
    var id: String { message }
    let message: String
}

enum Country: String, CaseIterable {
    case poland = "Poland"
    case germany = "Germany"
    case france = "France"
    case italy = "Italy"
}
```

### Tabs

Manage tabs:

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        RoutableTabView(router: router) { tab in
            tab.register(
                ProfileRoute(),
                label: { Label("Profile", systemImage: "person.crop.circle") }
            ) { route in
                NavigationStack {
                    ProfileView()
                }
            }

            tab.register(
                SettingsRoute(),
                label: { Label("Settings", systemImage: "gear") }
            ) { route in
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }
}

struct ProfileRoute: Routable {
    var id: String { "profile" }
}

struct SettingsRoute: Routable {
    var id: String { "settings" }
}
```

### Custom Presentations

Router supports custom transitions over UIKit. Just implement `CustomPresentationTransitionDelegateFactory` 
and use `.custom` presentationType:

```swift
struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        Button("Show Custom") {
            router.show(CustomRoute())
        }
        .route(
            CustomRoute.self, 
            in: router, 
            presentationType: .custom { dismissAction in
                MyCustomPresentationProvider(onDismiss: dismissAction)
            }
        ) { _ in
            CustomView()
        }
    }
}
```
A complete example with custom presentation is in the RouterAppExample.

### Composition

Compose multiple navigation flows seamlessly:

```swift
struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        NavigationStack {
            Button("Start Journey") {
                router.show(CityRoute(city: .paris))
            }
            .route(CityRoute.self, in: router, presentationType: .sheet) { route in
                CityView(city: route.city)
            }
            .route(CityGuideRoute.self, in: router, presentationType: .navigationStack) { route in
                CityGuideView(city: route.city)
            }
            .alertRoute(ConfirmationRoute.self, in: router)
        }
    }
}
```

## Advanced Usage

### Route Scope

The `.routeScope()` modifier is the key to properly managing router instances across your navigation hierarchy. It creates a new `Router` instance and injects it into the SwiftUI environment for a specific page.

**Important principles:**

- **One Router per Page**: Each presented or pushed screen should have its own `Router` instance
- **Shared within a Page**: All subviews within the same page share the same router via `@Environment(Router.self)`
- **Scope Boundaries**: Use `.routeScope()` when navigating to a new page to create a fresh router for that destination

#### Example: Root View with Route Scope

```swift
struct ContentView: View {
    var body: some View {
        NavigationStack {
            ProfileView()
                .routeScope()  // Creates a new router for the profile page
        }
    }
}
```

#### Example: Sharing Router Across Subviews

Within a single page, subviews access the same router from the environment:

```swift
struct ProfileView: View {
    @Environment(Router.self) var router
    
    var body: some View {
        VStack {
            ProfileHeaderView()  // Shares the same router
            ProfileActionsView()  // Shares the same router
            
            Button("Show Alert") {
                router.show(AlertRoute(message: "Profile page"))
            }
        }
        .alertRoute(AlertRoute.self, in: router)
    }
}

struct ProfileHeaderView: View {
    @Environment(Router.self) var router  // Same router instance
    
    var body: some View {
        Button("Edit Profile") {
            router.show(AlertRoute(message: "Profile updated"))
        }
    }
}

struct ProfileActionsView: View {
    @Environment(Router.self) var router  // Same router instance
    
    var body: some View {
        Button("Settings") {
            router.show(AlertRoute(message: "Profile settings updated"))
        }
    }
}
```

**Why Route Scope Matters:**

- **Isolation**: Each page's navigation state is isolated and won't interfere with parent or sibling pages
- **Memory Management**: Router instances are automatically cleaned up when their associated views are dismissed
- **Clarity**: Makes navigation boundaries explicit in your code
- **Predictability**: Prevents navigation state conflicts between different parts of your app

> [!TIP]
> When in doubt, follow this rule: If you're navigating to a new full screen (push, sheet, or full screen cover), add `.routeScope()` to the destination view. If you're just splitting up a single screen into reusable subviews, share the router via `@Environment`.

> [!TIP]
> You can follow the rule to never explicitely create Router instances but always use `.routeScope()` modifier and Environment. If the same view can be embeded as subview or presented as a new page `.routeScope()` will allow to define a new scope or use existing one.

### Protocol Composition

Create rich route types with metadata protocols:

```swift
struct ErrorRoute: Routable, TitleAwareProtocol, MessageAwareProtocol {
    var id: String { message }
    var title: String? { "Error Occurred" }
    let message: String
}

// Automatically uses title and message
view.alertRoute(ErrorRoute.self, in: router)
```

### Dismissing Routes

```swift
// From anywhere with access to the router
router.dismiss()

// Or use the standart environment value in your destination view
struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button("Close") {
            dismiss()
        }
    }
}
```

### Type Checking Current Route

```swift
if let profileRoute = router.item(as: ProfileRoute.self) {
    // Currently showing a profile route
    print("Viewing profile: \(profileRoute.userId)")
}
```

### Coordinator pattern

Router is a good friend of Coordinator pattern. Check RouterAppExample for "Coordinator pattern example one" and "Coordinator pattern example two"

```swift
struct AppCoordinator: View {
    @Environment(Router.self) var router

    var body: some View {
        RootView(output: .init(didSelectProfile: {
            router.show(ProfileRoute())
        }))
        .route(ProfileRoute.self, in: router, presentationType: .navigationStack) { _ in
            ProfileCoordinator()
                .routeScope()
        }
    }
}
```

## Architecture

Router uses a simple yet powerful architecture:

1. **`Router`**: An `@Observable` class that holds the current route item
2. **`Routable`**: A protocol requiring `Hashable` and `Identifiable<String>`
3. **View Modifiers**: SwiftUI extensions that bind router state to presentation APIs

The router automatically handles:
- State synchronization between multiple presentation types
- Sequential alert/sheet presentation edge cases
- Dismissal coordination
- Type-safe route matching

## Benefits

### Before Router

```swift
struct ContentView: View {
    @State private var showProfile = false
    @State private var showSettings = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedCity: City?

    var body: some View {
        // Complex binding management
        ZStack {
            Button(action: {
                showSettings = false
                showAlert = false
                selectedCity = nil
                showProfile = true
            }) {
                Text("Open profile")
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .alert(alertMessage, isPresented: $showAlert) { }
        .sheet(item: $selectedCity) { city in
            CityView(city: city)
        }
    }
}
```

### After Router

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        ZStack {
            Button(action: {
                // no need to dismiss previous route
                router.show(ProfileRoute())
            }) {
                Text("Open profile")
            }
        }
        .route(ProfileRoute.self, in: router, presentationType: .sheet) { _ in
            ProfileView()
        }
        .route(SettingsRoute.self, in: router, presentationType: .sheet) { _ in
            SettingsView()
        }
        .alertRoute(AlertRoute.self, in: router)
        .route(CityRoute.self, in: router, presentationType: .sheet) { route in
            CityView(city: route.city)
        }
    }
}

struct ProfileRoute: Routable {
    var id: String { "profile" }
}

struct SettingsRoute: Routable {
    var id: String { "settings" }
}

struct CityRoute: Routable {
    let city: City
    var id: String { city.rawValue }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile")
    }
}
```

or

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        ZStack {
            Button(action: {
                // no need to dismiss previous route
                router.show(SheetRoute.profile)
            }) {
                Text("Open profile")
            }
        }
        .route(SheetRoute.self, in: router, presentationType: .sheet) { route in
            switch route {
                case .profile: ProfileView()
                case .settings: SettingsView()
                case let .city(city): CityView(city: city)
            }
        }
        .alertRoute(AlertRoute.self, in: router)
    }
}

enum SheetRoute: Routable {
    var id: String {
        switch self {
        case .profile: return "profile"
        case .settings: return "settings"
        case let .city(city): return "city_\(city.rawValue)"
        }
    }

    case profile
    case settings
    case city(City)
}
```


## Requirements

- iOS 17.0+
- Swift 5.9+
- Xcode 15.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Router is available under the MIT license. See the LICENSE file for more info.

## Author

Created by Mikalai Zmachynski

## Acknowledgments

Built with modern SwiftUI patterns and the `@Observable` macro for optimal performance and developer experience.

