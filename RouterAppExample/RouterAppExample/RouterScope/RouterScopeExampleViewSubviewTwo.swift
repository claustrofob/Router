//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct RouterScopeExampleViewSubviewTwo: View {
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            Text("This is subview TWO of a view with a scope.")
            Button(action: {
                router.show(RouteScopeAlertRoute(message: "This is a message from subview TWO"))
            }) {
                Text("Show alert")
            }
        }
    }
}
