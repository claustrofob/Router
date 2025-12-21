import UIKit

@MainActor
@Observable public class UniversalLinkRouter {
    private var path: [any Routable] = []
    
    public init() {}
    
    public func route(to path: [any Routable]) {
        self.path = path
    }
    
    private func next() -> (any Routable)? {
        guard !path.isEmpty else {
            return nil
        }
        return path[0]
    }
    
    public func manage(_ perform: (any Routable) -> Bool) {
        guard let route = next() else {
            return
        }
        UIView.setAnimationsEnabled(false)
        if perform(route) {
            path.removeFirst()
        }
        if path.isEmpty {
            Task {
                try await Task.sleep(nanoseconds: 100_000_000)
                UIView.setAnimationsEnabled(true)
            }
        }
    }
}
