//
//  ContentView.swift
//  RouterAppExample
//
//  Created by Mikalai Zmachynski on 21/12/2025.
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
            }
            .background(.clear)
            .navigationTitle("Router App")
            .route(
                ExampleRouteItem.self,
                in: router, presentationType: .navigationStack
            ) { _ in
                SimpleViewsExample()
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
}

struct CustomPresentationRoute: Routable {
    var id: String { "customPresentation" }
}

#Preview {
    ContentView()
}
