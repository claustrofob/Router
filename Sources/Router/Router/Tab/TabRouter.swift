//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

/// A router dedicated to managing TabView navigation.
///
/// TabView always has an active tab, so a router that manages tabs must always keep its selected item
/// set to one of the available tabs. TabRouter is intentionally limited to tab navigation and does not
/// support presenting other route types, helping prevent misuse of routers for non-tab flows.
public final class TabRouter: AbstractRouter {
    override public init() {
        super.init()
    }
}
