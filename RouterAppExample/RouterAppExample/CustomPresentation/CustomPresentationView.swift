//
//  CustomPresentationView.swift
//  RouterAppExample
//
//  Created by Mikalai Zmachynski on 22/12/2025.
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
