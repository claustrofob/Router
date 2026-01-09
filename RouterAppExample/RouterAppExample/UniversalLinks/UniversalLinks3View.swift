//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks3View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 3 View")
            .navigationTitle("Universal Links 3")
            .route(UniversalLink4Route.self, in: router, presentationType: .navigationStack) { _ in
                UniversalLinks4View()
                    .environment(universalLinkRouter)
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink4Route: Routable {
    var id: String { "universalLink4" }
}
