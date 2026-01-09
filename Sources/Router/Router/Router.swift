//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Foundation

@MainActor
@Observable public final class Router {
    public var item: (any Routable)?
    private var registeredRoutes: [any Routable.Type] = []

    public init() {}

    public func show(_ item: some Routable) {
        self.item = nil
        // this fixes the problem with 2 subsequent alerts
        Task {
            self.item = item
        }
    }

    public func dismiss() {
        item = nil
    }

    public func item<To>(as _: To.Type = To.self) -> To? {
        item as? To
    }

    public func register(_ type: (some Routable).Type) {
        guard !isRegistered(type) else { return }
        registeredRoutes.append(type)
    }

    public func isRegistered(_ type: (some Routable).Type) -> Bool {
        registeredRoutes.contains(where: { $0 == type })
    }
}
