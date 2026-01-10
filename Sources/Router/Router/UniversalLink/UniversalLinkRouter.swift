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
    /// Registers a router instance with the universal link routing system.
    ///
    /// This method keeps a weak reference to the provided router, avoiding retain
    /// cycles and duplicate registrations. If the router isn't already present
    /// in the internal list, it's appended. After registration, the router is
    /// asked to process the next pending route (if any), enabling deferred
    /// universal link handling once a suitable router becomes available.
    ///
    /// - Parameter router: The `Router` to register and potentially use to
    ///   handle the next pending `Routable` item.
    func register(_ router: Router) {
        routers.reap()
        if !routers.contains(where: { $0.value === router }) {
            routers.append(Weak(router))
        }

        processNextItem(in: router)
    }

    /// Routes to the provided path of `Routable` items using the registered routers.
    ///
    /// This method compares the current router stack with the requested `path` and
    /// finds the first index at which they diverge (by matching `item.id`). It then:
    /// 1) Picks the router at the divergence point,
    /// 2) Stores the remaining segments of the requested path for deferred handling,
    /// 3) Dismisses the current presentation on that router without animation, and
    /// 4) Asks the router to process the next pending route segment.
    ///
    /// If there are no registered routers, or the router at the divergence index
    /// is unavailable, the call is a no-op.
    ///
    /// - Parameter path: An ordered list of `Routable` items representing the desired
    ///   navigation path (from root to destination). Consecutive leading items that
    ///   already match the existing router stack are skipped.
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
