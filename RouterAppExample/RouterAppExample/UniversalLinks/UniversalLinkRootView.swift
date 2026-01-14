//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct UniversalLinkRootView: View {
    @State var universalLinkRouter = UniversalLinkRouter()
    @State var tabRouter = TabRouter()

    var body: some View {
        RoutableTabView(router: tabRouter) { tab in
            tab.register(
                UniversalLinkTab1Route(),
                label: { Label("Tab 1", systemImage: "person.3.fill") }
            ) { _ in
                UniversalLinkTab1View()
            }

            tab.register(
                UniversalLinkTab2Route(),
                label: { Label("Tab 2", systemImage: "person.crop.circle") }
            ) { _ in
                UniversalLinkTab2View()
            }
        }
        .register(router: tabRouter, on: universalLinkRouter)
        .environment(universalLinkRouter)
    }
}

struct UniversalLinkTab1Route: Routable {
    var id: String { "tab1" }
}

struct UniversalLinkTab2Route: Routable {
    var id: String { "tab2" }
}
