//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    struct Output {
        var didSelectClose: () -> Void
        var didSelectSave: (String) -> Void
    }

    let output: Output

    var body: some View {
        Text("Edit profile")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { output.didSelectClose() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { output.didSelectSave("Profile data saved") }
                }
            }
    }
}
