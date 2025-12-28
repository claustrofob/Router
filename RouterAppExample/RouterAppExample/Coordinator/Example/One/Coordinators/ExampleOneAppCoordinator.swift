//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import SwiftUI

// In this example there is a separate coordinator for every page,
// because one router instance serves navigation within one page
struct ExampleOneAppCoordinator: View {
    @Environment(Router.self) var router

    var body: some View {
        RootView(output: .init(didSelectProfile: {
            router.show(ProfileRoute())
        }))
        .route(ProfileRoute.self, in: router, presentationType: .navigationStack) { _ in
            ExampleOneProfileCoordinator()
                .routerScope()
        }
    }
}
