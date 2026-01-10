//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

/// A scope view that creates and provides a `Router` instance to its content via the environment.
///
/// Use `RouterScopeView` to wrap parts of your hierarchy that need access to navigation routing.
public struct RouterScopeView<Content: View>: View {
    @State private var router = Router()

    @ViewBuilder public let content: (Router) -> Content

    public init(content: @escaping (Router) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(router).environment(router)
    }
}
