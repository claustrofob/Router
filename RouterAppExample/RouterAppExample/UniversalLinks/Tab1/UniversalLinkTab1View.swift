//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinkTab1View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Button(action: {
            // convert your real universal link into an array of routes.
            // The array should reflect the real structure of your app.
            // Every page decides on its own if it can manage and present the next route in UniversalLinkRouter
            universalLinkRouter.route(to: [
                UniversalLinkTab1Route(),
                UniversalLink11Route(),
                UniversalLink12Route(),
                UniversalLink13Route(),
                UniversalLink14Route(),
                UniversalLink14ConfirmationRoute(),
            ])
        }) {
            Text("Follow universal link")
        }
        .route(UniversalLink11Route.self, in: router, presentationType: .sheet) { _ in
            UniversalLinks11View()
                .environment(universalLinkRouter)
        }
        .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink11Route: Routable {
    var id: String { "universalLink1" }
}
