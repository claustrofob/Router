//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    struct Output {
        var didSelectEdit: () -> Void
        var didSelectSettings: () -> Void
    }

    let output: Output

    var body: some View {
        VStack {
            Button("Edit") {
                output.didSelectEdit()
            }.buttonStyle(.bordered)

            Button("Settings") {
                output.didSelectSettings()
            }.buttonStyle(.bordered)
        }
    }
}
