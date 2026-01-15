//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

public final class Router: AbstractRouter {
    public required init() {}

    override public func show(_ item: some Routable) {
        assertRegistration(item)

        self.item = nil
        // this fixes the problem with 2 subsequent alerts
        Task {
            self.item = item
        }
    }

    override public func dismiss() {
        item = nil
    }
}
