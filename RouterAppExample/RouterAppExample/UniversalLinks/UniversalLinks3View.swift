//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

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
            .onAppear {
                manageUniversalLink()
            }
    }

    private func manageUniversalLink() {
        universalLinkRouter.manage { route in
            if route is UniversalLink4Route {
                router.show(route)
                return true
            }
            return false
        }
    }
}

struct UniversalLink4Route: Routable {
    var id: String { "universalLink4" }
}
