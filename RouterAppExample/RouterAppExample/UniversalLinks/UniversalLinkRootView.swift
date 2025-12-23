//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct UniversalLinkRootView: View {
    @State var router = Router()
    @State var universalLinkRouter = UniversalLinkRouter()

    var body: some View {
        Button(action: {
            // convert your real universal link into an array of routes.
            // The array should reflect the real structure of your app.
            // Every page decides on its own if it can manage and present the next route in UniversalLinkRouter
            universalLinkRouter.route(to: [
                UniversalLink1Route(),
                UniversalLink2Route(),
                UniversalLink3Route(),
                UniversalLink4Route(),
                UniversalLink4ConfirmationRoute(),
            ])

            manageUniversalLink()
        }) {
            Text("Follow universal link")
        }
        .route(UniversalLink1Route.self, in: router, presentationType: .navigationStack) { _ in
            UniversalLinks1View()
                .environment(universalLinkRouter)
        }
        .environment(universalLinkRouter)
    }

    private func manageUniversalLink() {
        universalLinkRouter.manage { route in
            if route is UniversalLink1Route {
                router.show(route)
                return true
            }
            return false
        }
    }
}

struct UniversalLink1Route: Routable {
    var id: String { "universalLink1" }
}
