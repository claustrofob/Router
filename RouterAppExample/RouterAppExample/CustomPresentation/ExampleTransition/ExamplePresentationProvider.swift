//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import UIKit

public final class ExamplePresentationProvider: NSObject {
    private weak var presentationController: ExamplePresentationController?
    private let dismiss: CustomPresentationTransitionDismissAction

    public init(dismiss: @escaping CustomPresentationTransitionDismissAction) {
        self.dismiss = dismiss
    }
}

extension ExamplePresentationProvider: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source _: UIViewController
    ) -> UIPresentationController? {
        let presentationController = ExamplePresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.dismiss = dismiss
        self.presentationController = presentationController
        return presentationController
    }

    public func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        ExamplePresentationPresentingAnimator()
    }

    public func animationController(forDismissed _: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        ExamplePresentationDismissingAnimator()
    }

    public func interactionControllerForPresentation(using _: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        nil
    }

    public func interactionControllerForDismissal(using _: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        presentationController?.interactiveTransition
    }
}
