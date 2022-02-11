//
//  Card.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    let cardId: Int
    let pointsValue: Int
    
    init(cardId: Int) {
        self.cardId = cardId
        if cardId <= 13 {
            self.pointsValue = cardId
        } else {
            self.pointsValue = -1
        }
        
        let textureName = "Card_" + String(cardId)
        let texture = SKTexture(imageNamed: textureName)
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "Card"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
