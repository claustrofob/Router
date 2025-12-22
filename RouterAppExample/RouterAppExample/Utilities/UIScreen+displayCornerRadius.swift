//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

public extension UIScreen {
    var displayCornerRadius: CGFloat {
        guard let cornerRadius = value(forKey: "_displayCornerRadius") as? CGFloat else {
            return 0
        }
        return cornerRadius
    }
}
