//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

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
            .universalLinkObserver(universalLinkRouter, router: router) {
                $0 is UniversalLink3Route
            }
    }
}

struct UniversalLink3Route: Routable {
    var id: String { "universalLink3" }
}
