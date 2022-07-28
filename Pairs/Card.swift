// Card.swift

import UIKit

struct Card: Codable, Equatable {
    var name: String
    var color: Color

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }
}
