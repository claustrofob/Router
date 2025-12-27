import SwiftUI
import Router

struct ProfileEditCoordinator: View {
    struct Output {
        let didSelectClose: () -> Void
    }

    @Environment(Router.self) var router

    let output: Output

    var body: some View {
        ProfileEditView(output: .init(didSelectClose: {
            output.didSelectClose()
        }, didSelectSave: { message in
            router.show(AlertRoute(message: message))
        }))
        .alertRoute(AlertRoute.self, in: router)
    }
}
