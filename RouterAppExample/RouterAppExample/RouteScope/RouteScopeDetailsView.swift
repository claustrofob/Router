//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct RouteScopeDetailsView: View {
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            Text("This is a route scope details view")
            Button(action: {
                router.show(RouteScopeAlertRoute(message: "This is a message from details view"))
            }) {
                Text("Show alert")
            }
        }
        .alertRoute(
            RouteScopeAlertRoute.self,
            in: router
        )
    }
}
