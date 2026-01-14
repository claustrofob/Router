//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks11View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 1.1 View")
            .navigationTitle("Universal Links 1")
            .route(UniversalLink12Route.self, in: router, presentationType: .sheet) { _ in
                NavigationStack {
                    UniversalLinks12View()
                }
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink12Route: Routable {
    var id: String { "universalLink2" }
}
