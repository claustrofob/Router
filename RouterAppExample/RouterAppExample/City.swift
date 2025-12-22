//
//  Created by Mikalai Zmachynski.
//  Copyright © 2025 Mikalai Zmachynski. All rights reserved.
//

import Foundation

enum City: String, CaseIterable {
    case london = "London"
    case paris = "Paris"
    case newYork = "New York"
    case warsaw = "Warsaw"

    var description: String {
        switch self {
        case .london:
            "a historic yet modern capital, blending royal heritage, world-class museums, and diverse neighborhoods. From the Thames and iconic landmarks to vibrant theatre and finance districts, it offers a unique mix of tradition, culture, and global influence."
        case .paris:
            "renowned for its art, architecture, and romantic atmosphere. Elegant boulevards, historic cafés, and world-famous museums meet cutting-edge fashion and cuisine, making the city a timeless center of culture, creativity, and refined urban life."
        case .newYork:
            "a fast-paced global metropolis known for its skyline, cultural diversity, and creative energy. From Broadway and Central Park to tech, media, and finance hubs, it thrives on ambition, constant movement, and endless possibilities."
        case .warsaw:
            "a resilient city where history meets rapid modern growth. Carefully rebuilt old quarters stand beside contemporary architecture, while a dynamic tech scene, green spaces, and rich cultural life reflect its transformation and forward-looking spirit."
        }
    }
}
