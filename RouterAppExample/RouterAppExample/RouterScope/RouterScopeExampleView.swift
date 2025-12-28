//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct RouterScopeExampleView: View {
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            VStack {
                Text("This is a route scope view")
                Button(action: {
                    router.show(RouteScopeAlertRoute(message: "This is a message from root view"))
                }) {
                    Text("Show alert")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))

            HStack {
                Group {
                    RouterScopeExampleViewSubviewOne()
                    RouterScopeExampleViewSubviewTwo()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            }

            Button(action: {
                router.show(RouteScopeDetailsRoute())
            }) {
                Text("Open details page")
            }
        }
        .alertRoute(
            RouteScopeAlertRoute.self,
            in: router
        )
        .route(RouteScopeDetailsRoute.self, in: router, presentationType: .navigationStack) { _ in
            RouterScopeExampleDetailsView()
                // define a new route scope, because this is a new page
                .routerScope()
        }
    }
}

struct RouteScopeAlertRoute: Routable, MessageAwareProtocol {
    var id: String { message }
    let message: String
}

struct RouteScopeDetailsRoute: Routable {
    var id: String { "details" }
}
