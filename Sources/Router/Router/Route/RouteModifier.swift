//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
private struct RouteModifier<Route: Routable, NewRouteContent: View>: ViewModifier {
    private let type: Route.Type
    private let router: Router
    private let presentationType: RoutePresentationType
    @ViewBuilder private let routeContent: (Route) -> NewRouteContent

    private var typedItemBinding: Binding<Route?> {
        var storedItem: Route?
        return Binding(get: {
            if let item = router.item(as: type) {
                storedItem = item
                return item
            } else {
                return nil
            }
        }, set: { _ in
            if let item = router.item(as: type), item == storedItem {
                router.dismiss()
            }
        })
    }

    init(
        type: Route.Type,
        in router: Router,
        presentationType: RoutePresentationType,
        @ViewBuilder content: @escaping (Route) -> NewRouteContent
    ) {
        self.type = type
        self.router = router
        self.presentationType = presentationType
        routeContent = content
    }

    func body(content: Content) -> some View {
        switch presentationType {
        case .navigationStack:
            content.navigationDestination(item: typedItemBinding) { route in
                routeContent(route).id(route.id)
            }
        case .sheet:
            content.sheet(item: typedItemBinding) { route in
                routeContent(route).id(route.id)
            }
        case .fullScreen:
            content.fullScreenCover(item: typedItemBinding) { route in
                routeContent(route).id(route.id)
            }
        case let .custom(transitionDelegateFactory):
            content.customPresentation(item: typedItemBinding, transitionDelegateFactory: transitionDelegateFactory) { route in
                routeContent(route).id(route.id)
            }
        }
    }
}

@MainActor
public extension View {
    func route<Route: Routable>(
        _ type: Route.Type,
        in router: Router,
        presentationType: RoutePresentationType,
        @ViewBuilder content: @escaping (Route) -> some View
    ) -> some View {
        modifier(RouteModifier(
            type: type,
            in: router,
            presentationType: presentationType,
            content: content
        ))
    }
}
