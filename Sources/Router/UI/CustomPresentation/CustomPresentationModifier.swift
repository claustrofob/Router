//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import SwiftUI

struct CustomPresentationModifier<ViewContent: View, Item>: ViewModifier {
    @Binding private var item: Item?
    private let transitionDelegateFactory: CustomPresentationTransitionDelegateFactory
    @ViewBuilder private let viewContent: (Item) -> ViewContent
    
    public init(
        item: Binding<Item?>,
        transitionDelegateFactory: @escaping CustomPresentationTransitionDelegateFactory,
        @ViewBuilder viewContent: @escaping (Item) -> ViewContent
    ) {
        _item = item
        self.transitionDelegateFactory = transitionDelegateFactory
        self.viewContent = viewContent
    }
    
    func body(content: Content) -> some View {
        content.background(
            CustomPresentationView(
                item: $item,
                transitionDelegateFactory: transitionDelegateFactory,
                content: viewContent
            )
        )
    }
}

public extension View {
    func customPresentation<ViewContent: View, Item>(
        item: Binding<Item?>,
        transitionDelegateFactory: @escaping CustomPresentationTransitionDelegateFactory,
        @ViewBuilder viewContent: @escaping (Item) -> ViewContent
    ) -> some View {
        modifier(CustomPresentationModifier(
            item: item,
            transitionDelegateFactory: transitionDelegateFactory,
            viewContent: viewContent
        ))
    }
}
