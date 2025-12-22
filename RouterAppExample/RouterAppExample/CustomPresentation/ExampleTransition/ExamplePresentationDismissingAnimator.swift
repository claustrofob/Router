import UIKit

final class ExamplePresentationDismissingAnimator: NSObject {
    private enum Constants {
        static var duration: TimeInterval { 0.4 }
    }
    
    var animator: UIViewPropertyAnimator?
}
 
extension ExamplePresentationDismissingAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        Constants.duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        animator = ExamplePresentationDismissingAnimatorFactory(transitionContext: transitionContext).create()
        animator?.startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        animator = nil
    }
}
