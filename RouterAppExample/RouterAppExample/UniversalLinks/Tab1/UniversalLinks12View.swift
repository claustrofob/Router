//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks12View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 1.2 View")
            .navigationTitle("Universal Links 2")
            .route(UniversalLink13Route.self, in: router, presentationType: .sheet) { _ in
                NavigationStack {
                    UniversalLinks13View()
                }
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink13Route: Routable {
    var id: String { "universalLink3" }
}
