//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
private struct RouteModifier<Route: Routable, NewRouteContent: View>: ViewModifier {
    @Environment(\.routerNamespace) private var routerNamespace

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

        router.register(type)
    }

    func body(content: Content) -> some View {
        switch presentationType {
        case .navigationStack:
            content.navigationDestination(item: typedItemBinding) { route in
                routeContent(route)
                    .id(route.id)
                    .environment(\.routerNamespace, router.namespace(for: route))
            }
        case .sheet:
            content.sheet(item: typedItemBinding) { route in
                routeContent(route)
                    .id(route.id)
                    .environment(\.routerNamespace, router.namespace(for: route))
            }
        case .fullScreen:
            content.fullScreenCover(item: typedItemBinding) { route in
                routeContent(route)
                    .id(route.id)
                    .environment(\.routerNamespace, router.namespace(for: route))
            }
        case let .custom(transitionDelegateFactory):
            content.customPresentation(item: typedItemBinding, transitionDelegateFactory: transitionDelegateFactory) { route in
                routeContent(route)
                    .id(route.id)
                    .environment(\.routerNamespace, router.namespace(for: route))
            }
        }
    }
}

@MainActor
public extension View {
    /// Attaches routing for a specific `Routable` type to this view.
    ///
    /// This modifier registers the route type with the provided `Router` and
    /// presents content for a matching route using the specified `presentationType`.
    /// When the router publishes an item of the given type, the corresponding
    /// destination is shown and dismissed when the binding is cleared.
    ///
    /// - Parameters:
    ///   - type: The concrete `Routable` type to handle.
    ///   - router: The shared `Router` instance coordinating navigation.
    ///   - presentationType: How the route should be presented (navigation destination, sheet, full screen, or custom).
    ///   - content: A builder that returns the destination view for a given route instance.
    /// - Returns: A view that can present destinations for the given route type.
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
