import SwiftUI
import UIKit

final class ExamplePresentationInteractiveDismissingAnimator: NSObject, UIViewControllerInteractiveTransitioning {
    weak var transitionContext: (any UIViewControllerContextTransitioning)?
    private var animator: (any UIViewImplicitlyAnimating)?
    
    var isStarted: Bool {
        transitionContext != nil
    }
    
    func startInteractiveTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        animator = ExamplePresentationDismissingAnimatorFactory(transitionContext: transitionContext).create()
    }
    
    func gestureChanged(translation: CGFloat, velocity: CGFloat) {
        guard
            let transitionContext,
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            return
        }
        let distance = transitionContext.finalFrame(for: fromViewController).height
        var progress = translation / distance
        if progress < 0 {
            progress /= (1.0 + abs(progress * 20))
        }
        transitionContext.updateInteractiveTransition(progress)
        animator?.fractionComplete = progress
    }
    
    func gestureCancelled(translation: CGFloat, velocity: CGFloat) {
        guard let transitionContext else {
            return
        }
        animator?.isReversed = true
        continueAnimation(translation: translation, velocity: velocity)
        transitionContext.cancelInteractiveTransition()
    }
    
    func gestureEnded(translation: CGFloat, velocity: CGFloat) {
        guard
            let transitionContext,
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            return
        }
        let distance = transitionContext.finalFrame(for: fromViewController).height
        if velocity > 300 || (translation > distance / 2.0 && velocity > -300) {
            continueAnimation(translation: translation, velocity: velocity)
            transitionContext.finishInteractiveTransition()
        } else {
            gestureCancelled(translation: translation, velocity: velocity)
        }
    }
    
    private func continueAnimation(translation: CGFloat, velocity: CGFloat) {
        guard
            let transitionContext,
            let fromViewController = transitionContext.viewController(forKey: .from),
            let animator
        else {
            return
        }

        guard animator.state != .inactive else {
            transitionContext.completeTransition(false)
            return
        }

        let translation = max(translation, 0)
        let distance = !animator.isReversed
            ? transitionContext.finalFrame(for: fromViewController).height - translation
            : translation
        let relativeVelocityY = distance != 0 ? abs(velocity) / distance : 0
        
        let bounceRatio = min(relativeVelocityY, 100) / 150
        
        let relativeVelocity = CGVector(dx: 0, dy: relativeVelocityY)
        let spring = Spring(duration: 0.5, bounce: 1 * bounceRatio)
        let parameters = UISpringTimingParameters(
            mass: spring.mass,
            stiffness: spring.stiffness,
            damping: spring.damping,
            initialVelocity: relativeVelocity
        )

        animator.continueAnimation?(withTimingParameters: parameters, durationFactor: 1)
    }
}
