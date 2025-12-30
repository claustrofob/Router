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
        .route(SheetRoute.self, in: router, presentationType: .sheet) {
            ...
        }
        .route(FullScreenRoute.self, in: router, presentationType: .fullScreen) {
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
        .route(SheetRoute.self, in: router, presentationType: .sheet) {
            ...
        }
        .route(FullScreenRoute.self, in: router, presentationType: .fullScreen) {
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
