//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

struct CustomPresentationView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("View with custom presentation")
            Button(action: {
                dismiss()
            }) {
                Text("Dismiss")
            }
        }
    }
}
