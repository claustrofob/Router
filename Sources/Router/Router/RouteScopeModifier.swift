//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

private struct RouteScopeModifier: ViewModifier {
    @State private var router = Router()

    func body(content: Content) -> some View {
        content.environment(router)
    }
}

@MainActor
public extension View {
    func routeScope() -> some View {
        modifier(RouteScopeModifier())
    }
}
