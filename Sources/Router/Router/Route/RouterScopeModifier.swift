//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

private struct RouterScopeModifier: ViewModifier {
    @State private var router = Router()

    func body(content: Content) -> some View {
        content.environment(router)
    }
}

@MainActor
public extension View {
    /// Applies a Router scope to the view hierarchy by injecting a shared `Router`
    /// instance into the environment. Use this on a container view so all child views
    /// can access navigation via `@Environment(Router.self)`.
    func routerScope() -> some View {
        modifier(RouterScopeModifier())
    }
}
