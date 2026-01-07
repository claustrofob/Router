# Universal links

At this point, you may wonder how to programmatically navigate to a specific screen deep within the app hierarchy - for example, when implementing deep or universal links.

This task can be handled using native SwiftUI APIs such as NavigationStack(path:) with NavigationPath.
You register destination types and then append items to the navigation path. SwiftUI takes care of the rest:

```swift
struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Push some screens") {
                    path.append(FirstRoute())
                    path.append(SecondRoute())
                    path.append(ThirdRoute())
                }
            }
            .navigationDestination(for: FirstRoute.self) { _ in
                Text("First")
            }
            .navigationDestination(for: SecondRoute.self) { _ in
                Text("Second")
            }
            .navigationDestination(for: ThirdRoute.self) { _ in
                Text("Third")
            }
        }
    }
}

struct FirstRoute: Hashable {}
struct SecondRoute: Hashable {}
struct ThirdRoute: Hashable {}
```

However, this approach has several issues. First, NavigationPath allows appending the same items multiple times, in any order:

```
path.append(ThirdRoute())
path.append(SecondRoute())
path.append(FirstRoute())
path.append(ThirdRoute())
path.append(ThirdRoute())
```

This can be partially mitigated by applying `navigationDestination` to specific subviews, but it still does not fully solve the problem:

```swift
struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Push some screens") {
                    // This produces warnings but still works,
                    // and may go unnoticed in production
                    path.append(FirstRoute())
                    path.append(FirstRoute())
                    path.append(SecondRoute())
                    path.append(ThirdRoute())
                    path.append(ThirdRoute())
                }
            }
            .navigationDestination(for: FirstRoute.self) { _ in
                Text("First")
                    .navigationDestination(for: SecondRoute.self) { _ in
                        Text("Second")
                            .navigationDestination(for: ThirdRoute.self) { _ in
                                Text("Third")
                            }
                    }
            }
        }
    }
}
```

The second issue is that NavigationPath works only inside a NavigationStack.
But what about sheets, fullscreen covers, alerts, or custom presentations?
A navigation stack is just one presentation mechanism, similar to sheets or fullscreen covers.

Consider a common scenario with three screens: Dashboard, Profile, and Edit Profile. Profile and Edit Profile might be presented in a sheet, while Profile could also be pushed onto a navigation stack.
Alternatively, Dashboard and Profile could live inside a TabView. All of these approaches are valid and depend on design decisions.

If you rely solely on NavigationStack to support universal links and later decide to present some screens as sheets, you quickly run into limitations.

The Router package treats every presentation type - navigation stack, sheet, or fullscreen cover - as interchangeable and manages them in a unified way.
Each presentation (sheet, fullscreen cover, or navigation destination) defines its own presentation context and therefore requires its own Router instance.
Only the currently presented screen knows how to present the next one.

Universal link routing is performed as follows:
    1. A single UniversalLinkRouter instance is created at the root view. It stores a queue of routes that represents the app hierarchy to be presented.
    2. Each presented view dequeues the next route from UniversalLinkRouter and presents the corresponding screen.
    3. This process repeats until the queue is empty.

The initial example can be rewritten using Router and UniversalLinkRouter like this:

```swift
struct ContentView: View {
    @State var universalLinkRouter = UniversalLinkRouter()

    var body: some View {
        NavigationStack {
            // new presentation context
            RouterScopeView { router in
                VStack {
                    Button("Push some screens") {
                        universalLinkRouter.route(to: [
                            FirstRoute(), SecondRoute(), ThirdRoute()
                        ])
                    }
                }
                .route(
                    FirstRoute.self,
                    in: router,
                    presentationType: .navigationStack
                ) { _ in
                    // new presentation context
                    RouterScopeView { router in
                        Text("First")
                            .route(
                                SecondRoute.self,
                                in: router,
                                presentationType: .navigationStack
                            ) { _ in
                                // new presentation context
                                RouterScopeView { router in
                                    Text("Second")
                                        .route(
                                            ThirdRoute.self,
                                            in: router,
                                            presentationType: .navigationStack
                                        ) { _ in
                                            Text("Third")
                                        }
                                        .universalLinkObserver(
                                            universalLinkRouter,
                                            router: router
                                        ) { $0 is ThirdRoute }
                                }
                            }
                            .universalLinkObserver(
                                universalLinkRouter,
                                router: router
                            ) { $0 is SecondRoute }
                    }
                }
                .universalLinkStarter(
                    universalLinkRouter,
                    router: router
                ) { $0 is FirstRoute }
            }
        }
    }
}

struct FirstRoute: Routable {
    var id: String { "first" }
}
struct SecondRoute: Routable {
    var id: String { "second" }
}
struct ThirdRoute: Routable {
    var id: String { "third" }
}
```

With this approach, you can easily change the presentationType of any route.
For `.navigationStack`, simply wrap the view in a NavigationStack when needed—no changes to the universal link logic are required.

Check RouterAppExample for more examples on Universal links.
