//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

struct ContentView: View {
    @State var router = Router()

    var body: some View {
        NavigationStack {
            List {
                Button("Simple views example") {
                    router.show(ExampleRouteItem.simpleViews)
                }

                Button("Custom presentation") {
                    router.show(CustomPresentationRoute())
                }

                Button("Route scope example") {
                    router.show(ExampleRouteItem.routeScope)
                }

                Button(action: {
                    router.show(ExampleRouteItem.universalLinks)
                }) {
                    Text("Universal Links example")
                }

                Button("Coordinator pattern example one") {
                    router.show(ExampleRouteItem.coordinatorExampleOne)
                }

                Button("Coordinator pattern example two") {
                    router.show(ExampleRouteItem.coordinatorExampleTwo)
                }

                Button("Tab bar example") {
                    router.show(ExampleRouteItem.tabBarExample)
                }
            }
            .background(.clear)
            .navigationTitle("Router App")
            .route(
                ExampleRouteItem.self,
                in: router, presentationType: .navigationStack
            ) { route in
                switch route {
                case .simpleViews:
                    SimpleViewsExample()
                case .routeScope:
                    RouterScopeExampleView()
                        .routerScope()
                case .universalLinks:
                    UniversalLinkRootView()
                case .coordinatorExampleOne:
                    ExampleOneCoordinatorRootView()
                case .coordinatorExampleTwo:
                    ExampleTwoCoordinatorRootView()
                case .tabBarExample:
                    TabBarExampleView()
                        .routerScope(type: TabRouter.self)
                }
            }
            .route(
                CustomPresentationRoute.self,
                in: router,
                presentationType: .custom { dismiss in
                    ExamplePresentationProvider(dismiss: dismiss)
                }
            ) { _ in
                CustomPresentationView()
            }
        }
    }
}

enum ExampleRouteItem: String, Routable {
    var id: String { rawValue }
    case simpleViews
    case routeScope
    case universalLinks
    case coordinatorExampleOne
    case coordinatorExampleTwo
    case tabBarExample
}

struct CustomPresentationRoute: Routable {
    var id: String { "customPresentation" }
}

#Preview {
    ContentView()
}
