//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinkTab2View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Tab 2")
            .route(UniversalLink21Route.self, in: router, presentationType: .sheet) { _ in
                UniversalLinks21View()
                    .environment(universalLinkRouter)
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink21Route: Routable {
    var id: String { "universalLink1" }
}
