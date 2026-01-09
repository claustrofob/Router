//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

public extension View {
    func register(
        router: Router,
        on universalLinkRouter: UniversalLinkRouter
    ) -> some View {
        onFirstAppear {
            universalLinkRouter.register(router)
        }
    }
}
