//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinks14View: View {
    @Environment(UniversalLinkRouter.self) var universalLinkRouter
    @State var router = Router()

    var body: some View {
        VStack {
            Text("Universal Links 1.4 View")
            Button("Follow universal link 2") {
                universalLinkRouter.route(to: [
                    //                    UniversalLinkTab1Route(),
//                    UniversalLink1Route(),
//                    UniversalLink2Route(),
//                    UniversalLink3Route(),

                    UniversalLinkTab2Route(),
                    UniversalLink21Route(),
                ])
            }
        }
        .navigationTitle("Universal Links 4")
        .alertRoute(
            UniversalLink14ConfirmationRoute.self,
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
        .alertRoute(UniversalLink14AlertRoute.self, in: router) { _ in
            Text("This is final alert")
        }
        .register(router: router, on: universalLinkRouter)
    }
}

struct UniversalLink14ConfirmationRoute: Routable {
    var id: String { "universalLink4Confirmation" }
}

struct UniversalLink14AlertRoute: Routable {
    var id: String { "universalLink4Alert" }
}
