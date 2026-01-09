//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

final class ExamplePresentationDismissingAnimator: NSObject {
    private enum Constants {
        static var duration: TimeInterval { 0.8 }
    }

    var animator: UIViewPropertyAnimator?
}

extension ExamplePresentationDismissingAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using _: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Constants.duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        animator = ExamplePresentationDismissingAnimatorFactory(transitionContext: transitionContext).create()
        animator?.startAnimation()
    }

    func animationEnded(_: Bool) {
        animator = nil
    }
}
