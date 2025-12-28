//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct ContentView: View {
    @State var router = Router()

    var body: some View {
        NavigationStack {
            List {
                Button(action: {
                    router.show(ExampleRouteItem.simpleViews)
                }) {
                    Text("Simple views example")
                }

                Button(action: {
                    router.show(CustomPresentationRoute())
                }) {
                    Text("Custom presentation")
                }

                Button(action: {
                    router.show(ExampleRouteItem.routeScope)
                }) {
                    Text("Route scope example")
                }

                Button(action: {
                    router.show(ExampleRouteItem.universalLinks)
                }) {
                    Text("Universal Links example")
                }

                Button(action: {
                    router.show(ExampleRouteItem.coordinatorExampleOne)
                }) {
                    Text("Coordinator pattern example one")
                }

                Button(action: {
                    router.show(ExampleRouteItem.coordinatorExampleTwo)
                }) {
                    Text("Coordinator pattern example two")
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
                }
            }
            .route(
                CustomPresentationRoute.self,
                in: router,
                presentationType: .custom { dismiss in
                    ExamplePresentationProvider(dismiss: dismiss)
                }
            ) { route in
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
}

struct CustomPresentationRoute: Routable {
    var id: String { "customPresentation" }
}

#Preview {
    ContentView()
}
