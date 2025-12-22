import UIKit
import Router

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
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = ExamplePresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.dismiss = dismiss
        self.presentationController = presentationController
        return presentationController
    }
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        return ExamplePresentationPresentingAnimator()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        ExamplePresentationDismissingAnimator()
    }
    
    public func interactionControllerForPresentation(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        nil
    }
    
    public func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        presentationController?.interactiveTransition
    }
}
