//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks1View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 1 View")
            .navigationTitle("Universal Links 1")
            .route(UniversalLink2Route.self, in: router, presentationType: .sheet) { _ in
                NavigationStack {
                    UniversalLinks2View()
                }
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink2Route: Routable {
    var id: String { "universalLink2" }
}
