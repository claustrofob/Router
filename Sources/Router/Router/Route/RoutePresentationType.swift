//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

public enum RoutePresentationType {
    case navigationStack
    case sheet
    case fullScreen
    case custom(CustomPresentationTransitionDelegateFactory)
}
