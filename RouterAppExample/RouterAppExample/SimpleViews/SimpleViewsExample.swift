//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct SimpleViewsExample: View {
    @State var router = Router()

    var body: some View {
        ZStack {
            Button(action: {
                router.show(AlertRoute(message: "This is presented alert"))
            }) {
                Text("Present alert")
            }
        }
        .alertRoute(
            AlertRoute.self,
            in: router,
            presentationType: .alert,
            actionsContent: { _ in
                Button(action: {
                    router.show(ConfirmationRoute())
                }) {
                    Text("Present confirmation")
                }
            }
        )
        .alertRoute(
            ConfirmationRoute.self,
            in: router,
            presentationType: .confirmation,
            actionsContent: { _ in
                ForEach(City.allCases, id: \.self) { city in
                    Button(action: {
                        router.show(CityRoute(city: city))
                    }) {
                        Text("Go to \(city.rawValue)")
                    }
                }
            }
        )
        .route(
            CityRoute.self,
            in: router,
            presentationType: .sheet
        ) { route in
            VStack {
                Text("Welcome to \(route.city.rawValue)")
                    .font(.largeTitle)
                Button(action: {
                    router.show(CityGuideRoute(city: route.city))
                }) {
                    Text("Get city guide")
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .route(
            CityGuideRoute.self,
            in: router,
            presentationType: .navigationStack
        ) { route in
            VStack {
                Text(route.city.description)
                    .font(.subheadline)

                Button(action: {
                    router.dismiss()
                }) {
                    Text("Ok, go back")
                }
            }
            .navigationTitle(route.city.rawValue)
        }
    }
}

struct AlertRoute: Routable, MessageAwareProtocol {
    var id: String { message }
    let message: String
}

struct ConfirmationRoute: Routable, MessageAwareProtocol {
    var id: String { message }
    var message: String { "Choose where to go next:" }
}

struct CityRoute: Routable {
    var id: String { city.rawValue }
    let city: City
}

struct CityGuideRoute: Routable {
    var id: String { city.rawValue }
    let city: City
}
