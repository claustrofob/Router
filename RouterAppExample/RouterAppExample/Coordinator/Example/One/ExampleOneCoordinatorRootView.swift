//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI
import Router

struct ExampleOneCoordinatorRootView: View {
    var body: some View {
        ExampleOneAppCoordinator().routerScope()
            .navigationTitle("Example one")
    }
}
