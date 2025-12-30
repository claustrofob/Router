# Design Rationale

In pure SwiftUI, presenting a sheet, alert, or confirmation dialog is usually done using a Binding to a Bool or an Identifiable value:
```swift
@State private var sheetItem: SheetItem?

...

content.sheet(item: $sheetItem) { item in
    ...
}
```

This is a very nice approach that reflects the state-driven nature of SwiftUI. It looks clean, intuitive, and more advanced compared to the UIKit approach.

However, problems start to appear once you need to present multiple kinds of UI elements — such as alerts, confirmation dialogs, or pushing another view onto a NavigationStack.

The view state quickly becomes cluttered with multiple state variables:
```swift
@State private var sheetItem: SheetItem?
@State private var alertItem: AlertItem?
@State private var confirmationDialogIsPresented: Bool = false
@State private var isSettingsPagePresented: Bool = false
```

All of these variables might make sense if they could manage presented screens independently. But in reality, SwiftUI does not allow presenting more than one view at the same time.

For example, this state is logically invalid:
```swift
@State private var confirmationDialogIsPresented: Bool = true
@State private var isSettingsPagePresented: Bool = true
```

SwiftUI will not display a settings page on top of a confirmation dialog (or vice versa). Instead, it produces an error:
`Currently, only presenting a single sheet is supported.`

So effectively, Apple encourages us to use multiple variables to manage a single exclusive presentation state. This is a poor design choice.

Conceptually, presentation should be controlled by a single state variable. This is achievable when you are dealing with just one presentation type:
```swift
@State private var presentedItem: PresentedItem

...

content.sheet(item: $presentedItem) { item in
    ...
}
```

But the problem arises when you need to manage different presentation types - such as a sheet, confirmation dialog, alert and fullscreen cover - on the same screen.

Ideally, we would have a single state variable that controls all presentation types:
```swift

@State private var presentedItem: PresentedItem

...

content.sheet(item: $presentedItem) { item in
    ...
}.fullScreenCover(item: $presentedItem) { item in
    ...
}.alert(item: $presentedItem) { item in
    ...
}
```

Unfortunately, this approach does not work either.

**Router** fills a missing gap in proper presentation state management. It provides a single source of truth for all presentation items:
```swift
@State private var router = Router()
```

That’s it. A single router variable can manage different presentation types in a type-safe way. You simply register route items on the router:
```swift
content.route(SheetItem1.self, in: router, presentationType: .sheet) { item in
    ...
}
.route(SheetItem2.self, in: router, presentationType: .sheet) { item in
    ...
}
.route(FullScreenItem.self, in: router, presentationType: .fullScreen) { item in
    ...
}
.alertRoute(AlertItem1.self, in: router) { item in
    ...
}
.alertRoute(AlertItem2.self, in: router) { item in
    ...
}
```

Router goes even further and treats `navigationDestination` as another form of presentation, managing it through the same router state variable:
```swift
content.route(
    NavigationStackItem.self,
    in: router, presentationType: .navigationStack
) { item in
    ...
}
```

The only requirement for a route item is conformance to the `Routable` protocol, which is intentionally simple:
```swift
public protocol Routable: Hashable, Identifiable<String> {}
```

`Hashable` is required by `navigationDestination`, `Identifiable` is required by `sheet` and `fullScreenCover`, and `String` is used by `RoutableTabView`.

From this point on, presenting an item is as simple as calling `router.show(...)`. **Router** takes care of the rest - dismissing the currently presented item and presenting the new one.

# Further reading
- [Using Router in subviews](Subviews.md)
