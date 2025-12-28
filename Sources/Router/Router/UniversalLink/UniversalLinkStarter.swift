//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

public extension View {
    func universalLinkStarter(
        _ universalLinkRouter: UniversalLinkRouter,
        router: Router,
        perform: @escaping (any Routable) -> Bool
    ) -> some View {
        onChange(of: universalLinkRouter.isStarted) { _, newValue in
            guard newValue else { return }
            universalLinkRouter.manage {
                guard perform($0) else { return false }
                router.show($0)
                return true
            }
        }
    }
}
