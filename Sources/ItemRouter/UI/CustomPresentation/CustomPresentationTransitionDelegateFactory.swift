import UIKit

public typealias CustomPresentationTransitionDismissAction = () -> Void
public typealias CustomPresentationTransitionDelegateFactory = (@escaping CustomPresentationTransitionDismissAction) -> any UIViewControllerTransitioningDelegate
