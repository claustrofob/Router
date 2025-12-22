//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

@MainActor
public struct RoutableTabView<Content: View>: View {
    private let router: Router
    private let tab = RoutableTab()
    @ViewBuilder private let content: (RoutableTab) -> Content
    
    public init(
        router: Router,
        @ViewBuilder content: @escaping (RoutableTab) -> Content
    ) {
        self.router = router
        self.content = content
    }
    
    public var body: some View {
        TabView(selection: Binding<String>(get: {
            router.item?.id ?? tab.defaultRouteID ?? ""
        }, set: { id in
            guard let item = tab.route(by: id) else {
                return
            }
            router.item = item
        })) {
            let _ = tab.clear()
            content(tab)
        }
    }
}
