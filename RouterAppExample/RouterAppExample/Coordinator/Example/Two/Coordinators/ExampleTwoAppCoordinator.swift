//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

// In this example the entire navigation is located in this single coordinator.
// One router instance can serve navigation only within one page.
// To be able to implement navigation for several pages within one coordinator one can use `RouterScopeView`,
// that creates and provides a new router instance.
struct ExampleTwoAppCoordinator: View {
    @State private var rootRouter = Router()

    var body: some View {
        RootView(output: .init(didSelectProfile: {
            rootRouter.show(ProfileRoute())
        }))
        .route(ProfileRoute.self, in: rootRouter, presentationType: .navigationStack) { _ in
            // here is a new router scope that serves Profile page navigation
            RouterScopeView { profileRouter in
                ProfileView(output: .init(didSelectEdit: {
                    profileRouter.show(ProfileEditRoute())
                }, didSelectSettings: {
                    profileRouter.show(ProfileSettingsRoute())
                }))
                .route(ProfileEditRoute.self, in: profileRouter, presentationType: .sheet) { _ in
                    NavigationStack {
                        // here is a new router scope that serves Edit Profile page navigation
                        RouterScopeView { editProfileRouter in
                            ProfileEditView(output: .init(didSelectClose: {
                                profileRouter.dismiss()
                            }, didSelectSave: { message in
                                editProfileRouter.show(AlertRoute(message: message))
                            }))
                            .alertRoute(AlertRoute.self, in: editProfileRouter)
                        }
                    }
                }
                .route(ProfileSettingsRoute.self, in: profileRouter, presentationType: .navigationStack) { _ in
                    ProfileSettingsView()
                }
            }
        }
    }
}
