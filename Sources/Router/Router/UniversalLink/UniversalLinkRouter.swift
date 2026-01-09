//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import UIKit

@MainActor
@Observable public final class UniversalLinkRouter {
    private var routers = [Weak<Router>]()
    private var path: [any Routable] = []

    public init() {}

    private func next() -> (any Routable)? {
        guard !path.isEmpty else {
            return nil
        }
        return path[0]
    }

    private func processNextItem(in router: Router) {
        guard let route = next() else {
            return
        }
        performWithoutAnimation {
            if router.show(route) {
                path.removeFirst()
            }
        }
    }

    private func performWithoutAnimation(action: () -> Void) {
        UIView.setAnimationsEnabled(false)
        action()
        if path.isEmpty {
            Task {
                try await Task.sleep(nanoseconds: 100_000_000)
                UIView.setAnimationsEnabled(true)
            }
        }
    }
}

public extension UniversalLinkRouter {
    func register(_ router: Router) {
        routers.reap()
        if !routers.contains(where: { $0.value === router }) {
            routers.append(Weak(router))
        }

        processNextItem(in: router)
    }

    func route(to path: [any Routable]) {
        routers.reap()
        guard !routers.isEmpty else {
            return
        }

        var index = 0
        while
            index < routers.count,
            index < path.count,
            routers[index].value?.item?.id == path[index].id
        {
            index += 1
        }

        guard let router = routers[index].value else {
            return
        }

        self.path = Array(path[index...])
        performWithoutAnimation {
            router.dismiss()
        }

        processNextItem(in: router)
    }
}
