//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

enum RouterNamespaceKey: EnvironmentKey {
    static let defaultValue: RouterNamespace = Constants.rootRouterNamespace
}

extension EnvironmentValues {
    var routerNamespace: RouterNamespace {
        get { self[RouterNamespaceKey.self] }
        set { self[RouterNamespaceKey.self] = newValue }
    }
}
