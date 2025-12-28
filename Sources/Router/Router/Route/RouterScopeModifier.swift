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
    func routerScope() -> some View {
        modifier(RouterScopeModifier())
    }
}
