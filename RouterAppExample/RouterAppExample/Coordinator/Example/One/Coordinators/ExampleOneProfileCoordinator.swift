//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct ExampleOneProfileCoordinator: View {
    @Environment(Router.self) var router

    var body: some View {
        ProfileView(output: .init(didSelectEdit: {
            router.show(ProfileEditRoute())
        }, didSelectSettings: {
            router.show(ProfileSettingsRoute())
        }))
        .route(ProfileEditRoute.self, in: router, presentationType: .sheet) { _ in
            NavigationStack {
                ExampleOneProfileEditCoordinator(output: .init(didSelectClose: {
                    router.dismiss()
                }))
                .routerScope()
            }
        }
        .route(ProfileSettingsRoute.self, in: router, presentationType: .navigationStack) { _ in
            ProfileSettingsView()
        }
    }
}
