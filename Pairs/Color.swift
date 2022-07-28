// Color.swift

import UIKit

struct Color: Codable, Equatable {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }

    static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.uiColor == rhs.uiColor
    }
}
