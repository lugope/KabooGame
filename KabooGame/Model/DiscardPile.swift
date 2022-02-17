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
        currentTexture = SKTexture(imageNamed: "Card_\(pile.isEmpty ? "placeholder" : String(pile[0].type.rawValue))")
        
        super.init(texture: currentTexture, color: UIColor.clear, size: CGSize(width: CARD_SIZE_WIDTH, height: CARD_SIZE_HEIGHT))
        self.name = "Deck"
    }
    
    func draw() -> Card {
        let card = pile[0]
        pile.remove(at: 0)
        return card
    }
    
    func update() {
        self.texture = SKTexture(imageNamed: "Card_\(pile.isEmpty ? "placeholder" : String(pile[0].type.rawValue))")
    }
    
    func printPile() {
        for card in pile {
            print(card.type.value)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
