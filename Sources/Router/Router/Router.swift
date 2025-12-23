//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Foundation

@MainActor
@Observable public final class Router {
    public var item: (any Routable)?
    
    public init() {}
    
    public func show<Item: Routable>(_ item: Item) {
        self.item = nil
        // this fixes the problem with 2 subsequent alerts
        Task {
            self.item = item
        }
    }
    
    public func dismiss() {
        item = nil
    }
    
    public func item<To>(as: To.Type = To.self) -> To? {
        item as? To
    }
}
