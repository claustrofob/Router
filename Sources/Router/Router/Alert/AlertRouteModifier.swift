//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
private struct AlertRouteModifier<Route: Routable, MessageContent: View, ActionsContent: View>: ViewModifier {
    private let type: Route.Type
    private let router: Router
    private let presentationType: AlertPresentationType
    @ViewBuilder private let messageContent: (Route) -> MessageContent
    @ViewBuilder private let actionsContent: (Route) -> ActionsContent

    private var boolItemBinding: Binding<Bool> {
        var storedItem: Route?
        return Binding(get: {
            if let item = router.item(as: type) {
                storedItem = item
                return true
            } else {
                return false
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
        presentationType: AlertPresentationType,
        @ViewBuilder messageContent: @escaping (Route) -> MessageContent,
        @ViewBuilder actionsContent: @escaping (Route) -> ActionsContent
    ) {
        self.type = type
        self.router = router
        self.presentationType = presentationType
        self.messageContent = messageContent
        self.actionsContent = actionsContent
    }

    func body(content: Content) -> some View {
        switch presentationType {
        case .alert:
            content.alert(
                router.item(as: TitleAwareProtocol.self)?.title ?? "",
                isPresented: boolItemBinding,
                presenting: router.item(as: type),
                actions: { item in
                    actionsContent(item)
                },
                message: { item in
                    messageContent(item)
                }
            )
        case .confirmation:
            let title = router.item(as: TitleAwareProtocol.self)?.title ?? ""
            content.confirmationDialog(
                title,
                isPresented: boolItemBinding,
                titleVisibility: title.isEmpty ? .hidden : .visible,
                presenting: router.item(as: type),
                actions: { item in
                    actionsContent(item)
                },
                message: { item in
                    messageContent(item)
                }
            )
        }
    }
}

@MainActor
public extension View {
    func alertRoute<Route: Routable>(
        _ type: Route.Type,
        in router: Router,
        presentationType: AlertPresentationType = .alert,
        @ViewBuilder messageContent: @escaping (Route) -> some View,
        @ViewBuilder actionsContent: @escaping (Route) -> some View
    ) -> some View {
        modifier(AlertRouteModifier(
            type: type,
            in: router,
            presentationType: presentationType,
            messageContent: messageContent,
            actionsContent: actionsContent
        ))
    }

    func alertRoute<Route: Routable>(
        _ type: Route.Type,
        in router: Router,
        presentationType: AlertPresentationType = .alert,
        @ViewBuilder messageContent: @escaping (Route) -> some View
    ) -> some View {
        modifier(AlertRouteModifier(
            type: type,
            in: router,
            presentationType: presentationType,
            messageContent: messageContent,
            actionsContent: { _ in }
        ))
    }

    func alertRoute(
        _ type: (some Routable & MessageAwareProtocol).Type,
        in router: Router,
        presentationType: AlertPresentationType = .alert
    ) -> some View {
        modifier(AlertRouteModifier(
            type: type,
            in: router,
            presentationType: presentationType,
            messageContent: { route in Text(route.message) },
            actionsContent: { _ in }
        ))
    }

    func alertRoute<Route: Routable & MessageAwareProtocol>(
        _ type: Route.Type,
        in router: Router,
        presentationType: AlertPresentationType = .alert,
        @ViewBuilder actionsContent: @escaping (Route) -> some View
    ) -> some View {
        modifier(AlertRouteModifier(
            type: type,
            in: router,
            presentationType: presentationType,
            messageContent: { route in Text(route.message) },
            actionsContent: actionsContent
        ))
    }
}
