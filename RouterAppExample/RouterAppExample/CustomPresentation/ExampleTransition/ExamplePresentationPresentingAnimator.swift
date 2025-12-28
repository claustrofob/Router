//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

final class ExamplePresentationPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private enum Constants {
        static var duration: TimeInterval { 0.4 }
    }

    private var animator: UIViewPropertyAnimator?

    func transitionDuration(
        using _: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Constants.duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let presentationController = toViewController.presentationController as? ExamplePresentationController,
            let backView = presentationController.backView,
            let targetView = presentationController.targetView
        else {
            return
        }

        let animator = UIViewPropertyAnimator(
            duration: Constants.duration,
            controlPoint1: CGPoint(x: 0.16, y: 0.87),
            controlPoint2: CGPoint(x: 0.29, y: 0.99)
        )

        let translation = CGAffineTransform(
            translationX: 0,
            y: transitionContext.containerView.frame.height - presentationController.targetViewTopOffset
        )
        let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
        targetView.transform = CGAffineTransformConcat(scale, translation)

        animator.addAnimations {
            targetView.transform = .identity
            backView.slideOut()
        }
        animator.addCompletion { _ in
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        }
        animator.startAnimation()
        self.animator = animator
    }

    func animationEnded(_: Bool) {
        animator = nil
    }
}
