import SwiftUI
import Router

struct ProfileCoordinator: View {
    @Environment(Router.self) var router

    var body: some View {
        ProfileView(output: .init(didSelectEdit: {
            router.show(ProfileEditRoute())
        }, didSelectSettings: {
            router.show(ProfileSettingsRoute())
        }))
        .route(ProfileEditRoute.self, in: router, presentationType: .sheet) { _ in
            NavigationStack {
                ProfileEditCoordinator(output: .init(didSelectClose: {
                    router.dismiss()
                }))
                .routeScope()
            }
        }
        .route(ProfileSettingsRoute.self, in: router, presentationType: .navigationStack) { _ in
            ProfileSettingsView()
        }
    }
}
