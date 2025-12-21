import SwiftUI

public enum CloseEnvironmentKey: EnvironmentKey {
    public static let defaultValue = CloseAction {}
}

public extension EnvironmentValues {
    var close: CloseAction {
        get { self[CloseEnvironmentKey.self] }
        set { self[CloseEnvironmentKey.self] = newValue }
    }
}
