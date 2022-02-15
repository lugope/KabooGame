//
//  Card.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation
import SpriteKit

let CARD_FACEDOWN_TEXTURE = SKTexture(imageNamed: "Card_facedown")

class Card: SKSpriteNode {
    let type: CardType
    var faceUp: Bool = true
    
    init(cardType: CardType) {
        self.type = cardType
        
        super.init(texture: self.type.texture, color: UIColor.clear, size: self.type.texture.size())
        self.name = "Card"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CardType: Int {
    case card0 = 0, card1, card2, card3, card4, card5, card6, card7, card8, card9, card10, card11, card12, card13, card14
    
    var texture: SKTexture {
        let textureName = "Card_" + String(self.rawValue)
        return SKTexture(imageNamed: textureName)
    }
    
    var value: Int {
        if self.rawValue <= 13 {
            return self.rawValue
            
        } else {
            return -1
        }
    }
}
