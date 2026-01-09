//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks2View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 2 View")
            .navigationTitle("Universal Links 2")
            .route(UniversalLink3Route.self, in: router, presentationType: .sheet) { _ in
                NavigationStack {
                    UniversalLinks3View()
                }
            }
            .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink3Route: Routable {
    var id: String { "universalLink3" }
}
