//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import UIKit

final class ExamplePresentationBackView: UIView {
    private let containerView = UIView()
    private let dimmingView = UIView()
    private weak var targetView: UIView?
    private var displayLink: CADisplayLink?

    init(targetView: UIView?) {
        super.init(frame: .zero)
        self.targetView = targetView
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        pin(subview: containerView)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = UIScreen.main.displayCornerRadius

        containerView.pin(subview: dimmingView)
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .gray
    }

    @objc
    private func updateFrame() {
        if let targetView {
            // capture max possible area to get a full view image during rotation animation
            let maxSide = max(targetView.bounds.width, targetView.bounds.height)
            let captureRect = CGRect(x: 0, y: 0, width: maxSide, height: maxSide)
            let view = targetView.resizableSnapshotView(
                from: captureRect,
                afterScreenUpdates: false,
                withCapInsets: .zero
            )
            if let view {
                if containerView.subviews.count > 1 {
                    containerView.subviews.first?.removeFromSuperview()
                }
                containerView.insertSubview(view, at: 0)
            }
        }
        backgroundColor = window?.backgroundColor ?? .black
    }

    func startUpdates() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink?.add(to: .current, forMode: .common)
    }

    func stopUpdates() {
        displayLink?.invalidate()
        displayLink = nil
    }

    func slideOut() {
        containerView.transform = .init(scaleX: 0.9, y: 0.9)
        containerView.layer.cornerRadius = 20
        dimmingView.alpha = 0.2
    }

    func slideIn() {
        containerView.transform = .identity
        containerView.layer.cornerRadius = UIScreen.main.displayCornerRadius
        dimmingView.alpha = 0
    }
}
