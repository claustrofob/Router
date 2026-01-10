//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

/// Describes how a route should be presented to the user.
/// - Cases:
///   - `navigationStack`: Push onto a NavigationStack.
///   - `sheet`: Present modally as a page sheet.
///   - `fullScreen`: Present modally covering the entire screen.
///   - `custom`: Use a custom transitioning delegate provided by `CustomPresentationTransitionDelegateFactory`.
public enum RoutePresentationType {
    case navigationStack
    case sheet
    case fullScreen
    case custom(CustomPresentationTransitionDelegateFactory)
}
