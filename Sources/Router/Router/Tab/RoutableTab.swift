//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
public final class RoutableTab {
    private var routeIDs = [String]()
    private var routes: [String: any Routable] = [:]

    var defaultRouteID: String? {
        routeIDs.first
    }

    init() {}

    func append(_ route: some Routable) {
        guard routes[route.id] == nil else {
            return
        }
        routeIDs.append(route.id)
        routes[route.id] = route
    }

    func clear() {
        routeIDs.removeAll()
        routes.removeAll()
    }

    func route(by id: String) -> (any Routable)? {
        routes[id]
    }
}

public extension RoutableTab {
    func register<Route: Routable>(
        _ route: Route,
        @ViewBuilder label: @escaping () -> some View,
        @ViewBuilder content: @escaping (Route) -> some View
    ) -> some View {
        append(route)
        return content(route)
            .tabItem { label() }
            .tag(route.id)
    }
}
