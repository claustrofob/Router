//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
public final class RoutableTab {
    private let router: TabRouter

    var activeRouteID: String? {
        get {
            router.item?.id
        }
        set {
            guard let newValue else {
                router.item = nil
                return
            }

            guard let item = router.route(by: newValue) else {
                assertionFailure("Trying to set not registered route with id `\(newValue)` on TabRouter")
                return
            }

            router.item = item
        }
    }

    init(router: TabRouter) {
        self.router = router
    }

    func clear() {
        router.clear()
    }
}

public extension RoutableTab {
    func register<Route: Routable>(
        _ route: Route,
        @ViewBuilder label: @escaping () -> some View,
        @ViewBuilder content: @escaping (Route) -> some View
    ) -> some View {
        router.register(route)
        if #available(iOS 17, *) {
            // without this check build may fail with the following error:
            // Undefined symbol: opaque type descriptor for <<opaque return type of (extension in SwiftUI):SwiftUI.View.tag<A where A1: Swift.Hashable>(_: A1, includeOptional: Swift.Bool) -> some>>
            return content(route)
                .tabItem { label() }
                .tag(route.id)
                .environment(\.routerNamespace, router.namespace(for: route))
        } else {
            return content(route)
        }
    }
}
