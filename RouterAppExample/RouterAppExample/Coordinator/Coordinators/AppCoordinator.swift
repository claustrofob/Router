import SwiftUI
import Router

struct AppCoordinator: View {
    @Environment(Router.self) var router

    var body: some View {
        RootView(output: .init(didSelectProfile: {
            router.show(ProfileRoute())
        }))
        .route(ProfileRoute.self, in: router, presentationType: .navigationStack) { _ in
            ProfileCoordinator()
                .routeScope()
        }
    }
}
