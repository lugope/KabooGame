//
//  CustomColor.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct CustomColor {
    static let blue = Color("customBlue")
    static let darkGrey = Color("customDarkGrey")
    static let background = Color("background")
    static let gameBackground = Color("gameBackground")
    static let lightGrey = Color("customLightGrey")
}

extension UIColor {
    
    static func randomPlayerColor() -> UIColor {
        return [UIColor.blue, UIColor.gray, UIColor.green, UIColor.orange, UIColor.systemPink, UIColor.purple, UIColor.red, UIColor.yellow].randomElement() ?? UIColor.gray
    }
    
    static func getBySavedPicture(_ savedPicture: String) -> UIColor {
        switch savedPicture {
        case "profile.blue": return UIColor.blue
        case "profile.gray": return UIColor.gray
        case "profile.green": return UIColor.green
        case "profile.lightblue": return UIColor.blue
        case "profile.orange": return UIColor.orange
        case "profile.pink": return UIColor.systemPink
        case "profile.purple": return UIColor.purple
        case "profile.red": return UIColor.red
        case "profile.yellow": return UIColor.yellow
        default: return UIColor.gray
        }
    }
}
