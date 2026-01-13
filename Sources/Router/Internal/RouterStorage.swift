//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import Foundation

final class RouterStorage {
    private var routers = [RouterNamespace: Weak<AbstractRouter>]()

    var isEmpty: Bool {
        reap()
        return routers.isEmpty
    }

    private func reap() {
        routers = routers.filter { $1.value != nil }
    }

    func add(_ router: AbstractRouter, in namespace: RouterNamespace) {
        reap()
        if routers[namespace]?.value !== router {
            routers[namespace] = Weak(router)
        }
    }

    func router(by namespace: RouterNamespace) -> AbstractRouter? {
        routers[namespace]?.value
    }
}
