//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

public extension UIView {
    func pin(subview: UIView, with insets: UIEdgeInsets = .zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: -insets.left),
            topAnchor.constraint(equalTo: subview.topAnchor, constant: -insets.top),
            trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: insets.right),
            bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: insets.bottom),
        ])
    }
}
