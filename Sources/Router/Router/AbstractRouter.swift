//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Foundation

@MainActor
@Observable public class AbstractRouter {
    var item: (any Routable)?
    private var registeredTypes: Set<String> = []

    init() {}

    func register(_ type: (some Routable).Type) {
        guard !isRegistered(type) else { return }
        registeredTypes.insert("\(type)")
    }

    func isRegistered(_ type: (some Routable).Type) -> Bool {
        registeredTypes.contains("\(type)")
    }
}

public extension AbstractRouter {
    /// Presents a registered route by setting it as the current `item`.
    ///
    /// This method first verifies that the route's type has been registered via `register(_:)`.
    /// If the type is not registered, it triggers an assertion failure in debug builds and returns `false`.
    ///
    /// When showing a route, the current `item` is cleared first and then the new item is assigned
    /// on the next run loop tick using a `Task`. This deferred assignment helps avoid issues with
    /// back-to-back presentations (e.g., two subsequent alerts) where immediate reassignment might
    /// be ignored by SwiftUI.
    ///
    /// - Parameter item: The routable item to present.
    /// - Returns: `true` if the item type was registered and the presentation was scheduled; otherwise `false`.
    /// - Note: This method must be called on the main actor.
    @discardableResult
    func show(_ item: some Routable) -> Bool {
        let itemType = type(of: item)
        guard isRegistered(itemType) else {
            assertionFailure("Trying to show route `\(itemType)` that is not registered on this router instance")
            return false
        }

        self.item = nil
        // this fixes the problem with 2 subsequent alerts
        Task {
            self.item = item
        }
        return true
    }

    /// Dismisses the currently presented route, if any.
    ///
    /// Sets the current `item` to `nil`, causing any active presentation managed by
    /// the router to be cleared. Safe to call even if no route is currently shown.
    func dismiss() {
        item = nil
    }

    /// Returns the currently presented route cast to the specified type.
    ///
    /// Use this helper to safely retrieve `item` as a concrete type without exposing
    /// the erased `any Routable`. If the underlying `item` isn't of the requested
    /// type, the method returns `nil`.
    ///
    /// - Parameter as: The expected type to cast the current `item` to. Defaults to `To.self` so you can call `item()` with type inference.
    /// - Returns: The current route cast as `To`, or `nil` if the cast fails or no item is set.
    func item<To>(as _: To.Type = To.self) -> To? {
        item as? To
    }
}
