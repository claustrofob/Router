# Using Router in subviews

If you have read the [Design Rationale](README.md), you already know how to use `Router` and the `route` modifier. Let’s now look at more advanced usage scenarios.

### Router scope modifier

For example, consider the following code:

``` swift
struct ContentView: View {
    var body: some View {
        AppView()
    }
}

struct AppView: View {
    @State private var router = Router()

    var body: some View {
        VStack {
            AppSubView()
        }
        .route(SheetRoute.self, in: router, presentationType: .sheet) { _ in
            ...
        }
        .route(FullScreenRoute.self, in: router, presentationType: .fullScreen) { _ in
            ...
        }
    }
}
```

Now suppose you also want to use the router inside AppSubView. AppSubView shares the same presentation context as AppView, and a single presentation context must be managed by a single Router instance. Therefore, you need to pass the same router instance down to AppSubView:

```swift
struct AppView: View {
    @State private var router = Router()

    var body: some View {
        VStack {
            AppSubView(router: router)
        }
        ...
    }
}

struct AppSubView: View {
    let router: Router

    var body: some View {
        ...
    }
}
```

This works fine, but the Router package provides a more convenient solution: a modifier for creating a new router scope. It injects a Router instance into the environment, making it accessible from all subviews.

With this approach, the entire example can be rewritten as follows:

```swift
struct ContentView: View {
    var body: some View {
        AppView().routerScope()
    }
}

struct AppView: View {
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            AppSubView()
        }
        .route(SheetRoute.self, in: router, presentationType: .sheet) { _ in
            ...
        }
        .route(FullScreenRoute.self, in: router, presentationType: .fullScreen) { _ in
            ...
        }
    }
}

struct AppSubView: View {
    @Environment(Router.self) var router

    var body: some View {
        ...
    }
}
```

### Router scope view

RouterScopeView solves a different problem: it simplifies the creation and management of router instances in a multi-presentation-context environment. Consider the following code:

```swift
struct AppView: View {
    @State private var router = Router()

    var body: some View {
        VStack {
            ...
        }
        .route(SheetRoute1.self, in: router, presentationType: .sheet) { _ in
            VStack {
                ...
            }
            .route(SheetRoute2.self, in: router, presentationType: .sheet) { _ in
                ...
            }
        }
    }
}
```

This will not work because the code inside `.route(SheetRoute1.self, in: router, presentationType: .sheet)` creates a new presentation context and therefore requires a new router instance. A first attempt to fix this might look like this:

```swift
struct ContentView: View {
    @State private var router = Router()
    @State private var subRouter = Router()

    var body: some View {
        VStack {
            ...
        }
        .route(SheetRoute1.self, in: router, presentationType: .sheet) { _ in
            VStack {
                ...
            }
            .route(SheetRoute2.self, in: subRouter, presentationType: .sheet) { _ in
                ...
            }
        }
    }
}
```

This approach works and the problem is technically solved. However, it has drawbacks: the view’s scope becomes cluttered with multiple routers, and subRouter may retain state that is no longer valid or needed once SheetRoute1 is dismissed.

A more traditional solution is to split the code into two separate views:

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        VStack {
            ...
        }
        .route(SheetRoute1.self, in: router, presentationType: .sheet) { _ in
            ContentSubView()
        }
    }
}

struct ContentSubView: View {
    @State private var router = Router()

    var body: some View {
        VStack {
            ...
        }
        .route(SheetRoute2.self, in: router, presentationType: .sheet) { _ in
            ...
        }
    }
}
```

This solution is clean and works well. However, it may be inconvenient to create a new view every time you need a new router scope. This is where RouterScopeView comes to the rescue:

```swift
struct ContentView: View {
    @State private var router = Router()

    var body: some View {
        VStack {
            ...
        }
        .route(SheetRoute1.self, in: router, presentationType: .sheet) { _ in
            RouterScopeView { (router: Router) in
                VStack {
                    ...
                }
                .route(SheetRoute2.self, in: router, presentationType: .sheet) { _ in
                    ...
                }
            }
        }
    }
}
```

# Further reading

- [Universal links](UniversalLinks.md)
