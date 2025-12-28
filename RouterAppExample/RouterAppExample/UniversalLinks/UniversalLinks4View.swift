//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks4View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        Text("Universal Links 4 View")
            .navigationTitle("Universal Links 4")
            .alertRoute(
                UniversalLink4ConfirmationRoute.self,
                in: router,
                presentationType: .confirmation,
                messageContent: { _ in
                    Text("You are at the final destination")
                },
                actionsContent: { _ in
                    Button(action: {}) {
                        Text("Ok")
                    }
                }
            )
            .universalLinkObserver(universalLinkRouter, router: router) {
                $0 is UniversalLink4ConfirmationRoute
            }
    }
}

struct UniversalLink4ConfirmationRoute: Routable {
    var id: String { "universalLink4Confirmation" }
}
