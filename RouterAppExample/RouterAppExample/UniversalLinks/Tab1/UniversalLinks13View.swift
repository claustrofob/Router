//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks13View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 1.3 View")
            .navigationTitle("Universal Links 3")
            .route(UniversalLink14Route.self, in: router, presentationType: .navigationStack) { _ in
                UniversalLinks14View()
                    .environment(universalLinkRouter)
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink14Route: Routable {
    var id: String { "universalLink4" }
}
