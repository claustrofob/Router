//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
public struct RoutableTabView<Content: View>: View {
    private let tab: RoutableTab
    @ViewBuilder private let content: (RoutableTab) -> Content

    public init(
        router: TabRouter,
        @ViewBuilder content: @escaping (RoutableTab) -> Content
    ) {
        tab = RoutableTab(router: router)
        self.content = content
    }

    public var body: some View {
        TabView(selection: Binding<String?>(get: {
            tab.activeRouteID
        }, set: { id in
            tab.activeRouteID = id
        })) {
            let _ = tab.clear()
            content(tab)
        }
    }
}
