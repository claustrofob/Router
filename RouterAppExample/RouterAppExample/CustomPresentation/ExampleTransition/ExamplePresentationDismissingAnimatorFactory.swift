//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

@MainActor
final class ExamplePresentationDismissingAnimatorFactory: NSObject {
    private enum Constants {
        static var duration: TimeInterval { 0.4 }
    }
    
    private let transitionContext: any UIViewControllerContextTransitioning
    
    init(transitionContext: any UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
    
    func create() -> UIViewPropertyAnimator {
        let transitionContext = transitionContext
        let animator = UIViewPropertyAnimator(duration: Constants.duration, curve: .easeInOut)
        animator.addCompletion { _ in
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        }
        
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let presentationController = fromViewController.presentationController as? ExamplePresentationController,
            let backView = presentationController.backView,
            let targetView = presentationController.targetView
        else {
            return animator
        }

        let translation = CGAffineTransform(translationX: 0, y: targetView.frame.height)
        let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        animator.addAnimations {
            backView.slideIn()
            targetView.transform = CGAffineTransformConcat(scale, translation)
        }
        return animator
    }
}
