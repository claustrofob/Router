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
    
    func append<Route: Routable>(_ route: Route) {
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
    func register<Route: Routable, Label: View, Content: View>(
        _ route: Route,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder content: @escaping (Route) -> Content
    ) -> some View {
        append(route)
        if #available(iOS 17, *) {
            return content(route)
                .tabItem { label() }
                .tag(route.id)
        } else {
            return content(route)
        }
    }
}
