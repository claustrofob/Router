import UIKit

public extension UIViewController {
    static func swizzlePresent() {
        let originalSelector = #selector(present(_:animated:completion:))
        let swizzledSelector = #selector(swizzledPresent(_:animated:completion:))

        guard
            let originalMethod = class_getInstanceMethod(self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc func swizzledPresent(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if let navigationController {
            var targetViewController = self
            while
                navigationController.viewControllers.first(where: { $0 === targetViewController }) == nil,
                let parent = targetViewController.parent,
                parent !== navigationController {
                targetViewController = parent
            }

            if navigationController.viewControllers.first(where: { $0 === targetViewController }) != nil {
                navigationController.popToViewController(targetViewController, animated: animated)
            }
        }
        let sourceViewController = navigationController ?? self
        sourceViewController.swizzledPresent(viewControllerToPresent, animated: animated, completion: completion)
    }
}
