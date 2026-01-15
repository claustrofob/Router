//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

/// A router dedicated to managing TabView navigation.
///
/// TabView always has an active tab, so a router that manages tabs must always keep its selected item
/// set to one of the available tabs. TabRouter is intentionally limited to tab navigation and does not
/// support presenting other route types, helping prevent misuse of routers for non-tab flows.
public final class TabRouter: AbstractRouter {
    private var routeIDs = [String]()
    private var routes = [String: any Routable]()

    override var item: (any Routable)? {
        get {
            super.item ?? routeIDs.first.flatMap(route(by:))
        }
        set {
            super.item = newValue
        }
    }

    public required init() {}

    func register(_ route: some Routable) {
        guard routes[route.id] == nil else {
            return
        }
        routes[route.id] = route
        routeIDs.append(route.id)
        register(type(of: route))
    }

    func route(by id: String) -> (any Routable)? {
        routes[id]
    }

    func clear() {
        routes.removeAll()
        routeIDs.removeAll()
        clearRegistrations()
    }

    override public func show(_ item: some Routable) {
        assertRegistration(item)
        self.item = item
    }

    override public func dismiss() {}
}
