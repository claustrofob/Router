//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

private struct RouterRegisterModifier: ViewModifier {
    @Environment(\.routerNamespace) private var routerNamespace
    let router: AbstractRouter
    let universalLinkRouter: UniversalLinkRouter

    func body(content: Content) -> some View {
        content.task {
            try? await Task.sleep(nanoseconds: 10_000_000)
            universalLinkRouter.register(router, namespace: routerNamespace)
        }
    }
}

public extension View {
    /// Registers a `Router` with the provided `UniversalLinkRouter` on the first appearance of the view.
    ///
    /// Use this modifier to connect a `Router` to a shared `UniversalLinkRouter` so that
    /// universal links (or other external routing events) can be handled by this view hierarchy.
    /// Registration occurs once, the first time the view appears, via `onFirstAppear`.
    ///
    /// - Parameters:
    ///   - router: The view's `Router` instance to register for handling navigation actions.
    ///   - universalLinkRouter: The shared `UniversalLinkRouter` that coordinates universal link routing.
    /// - Returns: A view that performs the registration on first appearance and otherwise renders unchanged.
    func register(
        router: AbstractRouter,
        on universalLinkRouter: UniversalLinkRouter
    ) -> some View {
        modifier(RouterRegisterModifier(router: router, universalLinkRouter: universalLinkRouter))
    }
}
