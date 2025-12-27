import SwiftUI
import Router

struct CoordinatorRootView: View {
    var body: some View {
        AppCoordinator().routeScope()
    }
}
