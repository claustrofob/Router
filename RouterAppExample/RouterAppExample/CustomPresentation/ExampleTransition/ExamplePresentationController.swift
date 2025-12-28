//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Router
import UIKit

class ExamplePresentationController: UIPresentationController {
    var interactiveTransition: ExamplePresentationInteractiveDismissingAnimator?

    var dismiss: CustomPresentationTransitionDismissAction?
    var backView: ExamplePresentationBackView?
    var targetView: UIView?
    var targetViewTopOffset: CGFloat {
        isLandscape ? 0 : 60
    }

    private var targetTopConsraint: NSLayoutConstraint?

    private var isLandscape: Bool {
        containerView.flatMap {
            $0.bounds.width > $0.bounds.height
        } ?? false
    }

    override func presentationTransitionWillBegin() {
        guard let containerView else {
            return
        }

        let backView = ExamplePresentationBackView(targetView: presentingViewController.view)
        containerView.pin(subview: backView)
        self.backView = backView
        backView.startUpdates()

        let targetView = UIView()
        targetView.clipsToBounds = true
        targetView.layer.cornerRadius = 20
        targetView.pin(subview: presentedViewController.view)
        targetView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(targetView)
        let targetTopConsraint = targetView.topAnchor.constraint(equalTo: containerView.topAnchor)
        self.targetTopConsraint = targetTopConsraint
        NSLayoutConstraint.activate([
            targetView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            targetTopConsraint,
            targetView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            targetView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        targetTopConsraint.constant = targetViewTopOffset

        self.targetView = targetView
    }

    override func presentationTransitionDidEnd(_: Bool) {
        guard let containerView else {
            return
        }

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gestureRecognizer.maximumNumberOfTouches = 1
        containerView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            let view = gestureRecognizer.view,
            (!presentedViewController.isBeingDismissed || interactiveTransition?.isStarted == true)
        else {
            return
        }
        let translation = gestureRecognizer.translation(in: view).y
        let velocity = gestureRecognizer.velocity(in: view).y
        switch gestureRecognizer.state {
        case .began:
            guard !presentedViewController.isBeingDismissed else {
                return
            }
            interactiveTransition = ExamplePresentationInteractiveDismissingAnimator()
            presentedViewController.dismiss(animated: true)
        case .changed:
            interactiveTransition?.gestureChanged(translation: translation, velocity: velocity)
        case .ended:
            interactiveTransition?.gestureEnded(translation: translation, velocity: velocity)
            interactiveTransition = nil
        case .cancelled:
            interactiveTransition?.gestureCancelled(translation: translation, velocity: velocity)
            interactiveTransition = nil
        default:
            ()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            guard let self else {
                return
            }
            targetTopConsraint?.constant = targetViewTopOffset
            containerView?.layoutIfNeeded()
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else {
            return
        }
        dismiss?()
        dismiss = nil
        backView?.stopUpdates()
        backView = nil
        targetView = nil
        targetTopConsraint = nil
    }
}
