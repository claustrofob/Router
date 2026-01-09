//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct TabBarExampleView: View {
    @State var router = Router()

    var body: some View {
        RoutableTabView(router: router) { tab in
            tab.register(
                TabMessagesRoute(),
                label: { Label("Messages", systemImage: "message") }
            ) { _ in
                VStack {
                    Text("Messages tab")
                    Button("Go to Profile tab") {
                        router.show(TabProfileRoute())
                    }
                }
            }

            tab.register(
                TabContactsRoute(),
                label: { Label("Contacts", systemImage: "person.3.fill") }
            ) { _ in
                Text("Contacts tab")
            }

            tab.register(
                TabProfileRoute(),
                label: { Label("Profile", systemImage: "person.crop.circle") }
            ) { _ in
                Text("Profile tab")
            }
        }
    }
}

struct TabMessagesRoute: Routable {
    var id: String { "tab.messages" }
}

struct TabContactsRoute: Routable {
    var id: String { "tab.contacts" }
}

struct TabProfileRoute: Routable {
    var id: String { "tab.profile" }
}
