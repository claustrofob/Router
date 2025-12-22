//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct RouteScopeViewSubviewOne: View {
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            Text("This is subview ONE of a view with a scope.")
            Button(action: {
                router.show(RouteScopeAlertRoute(message: "This is a message from subview ONE"))
            }) {
                Text("Show alert")
            }
        }
    }
}

