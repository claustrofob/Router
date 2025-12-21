import UIKit

public enum RoutePresentationType {
    case navigationStack
    case sheet
    case fullScreen
    case custom(CustomPresentationTransitionDelegateFactory)
}
