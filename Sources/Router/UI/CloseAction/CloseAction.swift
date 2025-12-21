import SwiftUI

public struct CloseAction: Sendable {
    private let closure: @Sendable @MainActor () -> Void

    public init(_ closure: @Sendable @MainActor @escaping () -> Void) {
        self.closure = closure
    }

    @MainActor
    public func callAsFunction() {
        closure()
    }
}
