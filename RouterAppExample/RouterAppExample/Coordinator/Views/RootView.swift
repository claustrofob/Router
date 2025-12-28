//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

struct RootView: View {
    struct Output {
        var didSelectProfile: () -> Void
    }

    let output: Output

    var body: some View {
        VStack {
            Button("Open profile") {
                output.didSelectProfile()
            }.buttonStyle(.bordered)
        }
    }
}
