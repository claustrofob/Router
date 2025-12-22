//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

struct CustomPresentationView<ViewContent: View, Item>: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    final class PresentedViewController: UIHostingController<ViewContent> {
        var transitionDelegate: (any UIViewControllerTransitioningDelegate)? {
            didSet {
                transitioningDelegate = transitionDelegate
            }
        }
    }
    
    final class Coordinator {
        weak var presentedViewController: PresentedViewController?
        init() {}
    }
    
    @Binding private var item: Item?
    private let transitionDelegateFactory: CustomPresentationTransitionDelegateFactory
    @ViewBuilder private let content: (Item) -> ViewContent
    
    init(
        item: Binding<Item?>,
        transitionDelegateFactory: @escaping CustomPresentationTransitionDelegateFactory,
        @ViewBuilder content: @escaping (Item) -> ViewContent
    ) {
        _item = item
        self.transitionDelegateFactory = transitionDelegateFactory
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // DispatchQueue.main.async fixes the bug with NavigationStack in presented view controller is connected to a parent NavigationStack
        // https://stackoverflow.com/questions/78991713/navigationstack-in-a-custom-presented-view-is-connected-to-navigationstack-of-th
        if let item {
            // view builder must be called outside of DispatchQueue.main.async
            // otherwise it does not track updates from the parent view
            let view = content(item)
            DispatchQueue.main.async {
                if let vc = context.coordinator.presentedViewController {
                    vc.rootView = view
                } else {
                    let presentedViewController = PresentedViewController(rootView: view)
                    presentedViewController.modalPresentationStyle = .custom
                    presentedViewController.transitionDelegate = transitionDelegateFactory {
                        self.item = nil
                    }
                    context.coordinator.presentedViewController = presentedViewController
                    uiViewController.present(presentedViewController, animated: true)
                }
            }
        } else if
            let vc = context.coordinator.presentedViewController,
            !vc.isBeingDismissed {
            vc.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
