//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

public typealias CustomPresentationTransitionDismissAction = () -> Void
public typealias CustomPresentationTransitionDelegateFactory = (@escaping CustomPresentationTransitionDismissAction) -> any UIViewControllerTransitioningDelegate
