//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Foundation

@MainActor
@Observable public class AbstractRouter {
    private let id = UUID().uuidString

    var item: (any Routable)?

    @ObservationIgnored
    private var registeredTypes: Set<String> = []

    required init() {}

    // MARK: internal

    func assertRegistration(_ item: some Routable) {
        let type = type(of: item)
        assert(
            registeredTypes.contains("\(type)"),
            "Trying to show route `\(type)` that is not registered on this router instance"
        )
    }

    func register(_ type: (some Routable).Type) {
        registeredTypes.insert("\(type)")
    }

    func clearRegistrations() {
        registeredTypes.removeAll()
    }

    func namespace(for route: any Routable) -> RouterNamespace {
        "\(id)_\(route.id)"
    }

    // MARK: public

    /// Presents a registered route by setting it as the current `item`.
    public func show(_: some Routable) {
        fatalError("Not implemented")
    }

    /// Dismisses the currently presented route, if any.
    public func dismiss() {
        fatalError("Not implemented")
    }

    /// Returns the currently presented route cast to the specified type.
    public func item<To>(as _: To.Type = To.self) -> To? {
        item as? To
    }
}
