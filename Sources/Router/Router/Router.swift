//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Foundation

@MainActor
@Observable public final class Router {
    var item: (any Routable)?
    private var registeredItems: [any Routable.Type] = []

    public init() {}

    func register(_ type: (some Routable).Type) {
        guard !isRegistered(type) else { return }
        registeredItems.append(type)
    }

    func isRegistered(_ type: (some Routable).Type) -> Bool {
        registeredItems.contains(where: { $0 == type })
    }
}

public extension Router {
    @discardableResult
    func show(_ item: some Routable) -> Bool {
        let itemType = type(of: item)
        guard isRegistered(itemType) else {
            assertionFailure("Trying to show unregistered route: \(itemType)")
            return false
        }

        self.item = nil
        // this fixes the problem with 2 subsequent alerts
        Task {
            self.item = item
        }
        return true
    }

    func dismiss() {
        item = nil
    }

    func item<To>(as _: To.Type = To.self) -> To? {
        item as? To
    }
}
