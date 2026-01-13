//
//  Created by Mikalai Zmachynski.
//  Copyright © 2026 Mikalai Zmachynski. All rights reserved.
//

import UIKit

@MainActor
@Observable public final class UniversalLinkRouter {
    private var rootNamespace = Constants.rootRouterNamespace
    private let storage = RouterStorage()
    private var path: [any Routable] = []
    private var integrityCheckTask: Task<Void, Error>?

    public init() {}

    private func processNextItem(in router: AbstractRouter) {
        guard !path.isEmpty else {
            return
        }
        let route = path.removeFirst()
        performWithoutAnimation {
            router.show(route)
            startIntegrityCheckTask()
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

    private func startIntegrityCheckTask() {
        integrityCheckTask?.cancel()
        integrityCheckTask = Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            assert(path.isEmpty, "UniversalLinkRouter: some routes were not shown \(path)")
        }
    }

    func register(_ router: AbstractRouter, namespace: RouterNamespace) {
        if storage.isEmpty {
            rootNamespace = namespace
        }
        storage.add(router, in: namespace)
        processNextItem(in: router)
    }
}

public extension UniversalLinkRouter {
    func route(to path: [any Routable]) {
        guard !storage.isEmpty else {
            return
        }

        var namespace = rootNamespace
        var index = 0
        while
            index < path.count,
            let router = storage.router(by: namespace),
            router.item?.id == path[index].id
        {
            namespace = router.namespace(for: path[index])
            index += 1
        }

        guard let router = storage.router(by: namespace) else {
            return
        }

        self.path = Array(path[index...])
        performWithoutAnimation {
            router.dismiss()
        }

        processNextItem(in: router)
    }
}
