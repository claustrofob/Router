//
//  File.swift
//  Router
//
//  Created by Mikalai Zmachynski on 22/12/2025.
//

import SwiftUI

private struct RouteScopeModifier: ViewModifier {
    @State private var router = Router()

    func body(content: Content) -> some View {
        content.environment(router)
    }
}

@MainActor
public extension View {
    func routeScope() -> some View {
        modifier(RouteScopeModifier())
    }
}
