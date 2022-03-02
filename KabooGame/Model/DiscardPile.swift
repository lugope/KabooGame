//
//  DiscardPile.swift
//  KabooGame
//
//  Created by Danil Masnaviev on 15/02/22.
//

import Foundation
import SpriteKit

class DiscardPile: SKSpriteNode {
    var currentTexture: SKTexture
    var pile: [Card] = []
    
    init() {
        currentTexture = SKTexture(imageNamed: "Card_placeholder")
        
        super.init(texture: currentTexture, color: UIColor.clear, size: CGSize(width: CARD_SIZE_WIDTH, height: CARD_SIZE_HEIGHT))
        self.name = "Pile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() -> Card {
        let card = pile[0]
        pop()
        return card
    }
    
    func pop() {
        pile.remove(at: 0)
    }
    
    func update() {
        var textureName = "placeholder"
        if pile.count >= 2 {
            textureName = String(pile[1].type.rawValue)
        }
        
        self.texture = SKTexture(imageNamed: "Card_\(textureName)")
    }
    
    func printPile() {
        for card in pile {
            print(card.type.value)
        }
    }
}
