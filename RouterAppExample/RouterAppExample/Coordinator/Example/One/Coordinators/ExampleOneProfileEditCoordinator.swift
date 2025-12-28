//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct ExampleOneProfileEditCoordinator: View {
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
