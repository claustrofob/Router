//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

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
