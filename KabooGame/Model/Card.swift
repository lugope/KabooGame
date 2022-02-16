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
    let frontTexture: SKTexture
    let backTexture: SKTexture
    var faceUp = false
    
    init(cardId: Int) {
        self.cardId = cardId
        if cardId <= 13 {
            self.pointsValue = cardId
        } else {
            self.pointsValue = -1
        }
        
        let textureName = "Card_" + String(cardId)
        frontTexture = SKTexture(imageNamed: textureName)
        backTexture = SKTexture(imageNamed: "Card_back")
        
        super.init(texture: backTexture, color: UIColor.clear, size: backTexture.size())
        self.name = "Card"
    }
    
    func flip() {
        if faceUp {
            self.texture = backTexture
        } else {
            self.texture = frontTexture
        }
        faceUp = !faceUp
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
