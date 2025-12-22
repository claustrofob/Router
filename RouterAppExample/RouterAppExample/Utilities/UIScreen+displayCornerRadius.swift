//
//  UIScreen+displayCornerRadius.swift
//  RouterAppExample
//
//  Created by Mikalai Zmachynski on 22/12/2025.
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
