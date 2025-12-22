//
//  RouteScopeView.swift
//  RouterAppExample
//
//  Created by Mikalai Zmachynski on 22/12/2025.
//

import SwiftUI
import Router

struct RouteScopeView: View {
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            VStack {
                Text("This is a route scope view")
                Button(action: {
                    router.show(RouteScopeAlertRoute(message: "This is a message from root view"))
                }) {
                    Text("Show alert")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))

            HStack {
                Group {
                    RouteScopeViewSubviewOne()
                    RouteScopeViewSubviewTwo()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            }

            Button(action: {
                router.show(RouteScopeDetailsRoute())
            }) {
                Text("Open details page")
            }
        }
        .alertRoute(
            RouteScopeAlertRoute.self,
            in: router
        )
        .route(RouteScopeDetailsRoute.self, in: router, presentationType: .navigationStack) { _ in
            RouteScopeDetailsView()
                // define a new route scope, because this is a new page
                .routeScope()
        }
    }
}

struct RouteScopeAlertRoute: Routable, MessageAwareProtocol {
    var id: String { message }
    let message: String
}

struct RouteScopeDetailsRoute: Routable {
    var id: String { "details" }
}
