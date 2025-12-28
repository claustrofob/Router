//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

public extension View {
    func universalLinkObserver(
        _ universalLinkRouter: UniversalLinkRouter,
        router: Router,
        perform: @escaping (any Routable) -> Bool
    ) -> some View {
        onAppear {
            universalLinkRouter.manage {
                guard perform($0) else { return false }
                router.show($0)
                return true
            }
        }
    }
}
