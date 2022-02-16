//
//  Card.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation
import SpriteKit

let CARD_BACK_TEXTURE = SKTexture(imageNamed: "Card_back")
let CARD_PLACEHOLDER_TEXTURE = SKTexture(imageNamed: "Card_placeholder")
let CARD_SIZE_WIDTH: CGFloat = 72
let CARD_SIZE_HEIGHT: CGFloat = 108

class Card: SKSpriteNode {
    
    let type: CardType
    var faceUp: Bool = false
    
    init(cardType: CardType) {
        self.type = cardType
        
        super.init(
            texture: self.type.texture,
            color: UIColor.clear,
            size: CGSize(width: CARD_SIZE_WIDTH, height: CARD_SIZE_HEIGHT)
        )
        
        self.name = "Card"
    }
    
    convenience init(cardType: Int) {
        let type: CardType = CardType(rawValue: cardType) ?? CardType.placeholder
        self.init(cardType: type)
    }
    
    func flip() {
        if faceUp {
            self.texture = type.texture
        } else {
            self.texture = CARD_BACK_TEXTURE
        }
        
        faceUp = !faceUp
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CardType: Int {
    case card0 = 0, card1, card2, card3, card4, card5, card6, card7, card8, card9, card10, card11, card12, card13, jocker, placeholder
    
    var texture: SKTexture {
        if self == CardType.placeholder {
            return CARD_PLACEHOLDER_TEXTURE
            
        } else {
            let textureName = "Card_" + String(self.rawValue)
            return SKTexture(imageNamed: textureName)
        }
    }
    
    var value: Int {
        if self.rawValue <= 13 {
            return self.rawValue
            
        } else if self == .jocker  {
            return -1
            
        } else {
            return 0
        }
    }
}
