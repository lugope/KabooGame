//
//  Deck.swift
//  KabooGame
//
//  Created by Danil Masnaviev on 15/02/22.
//

import Foundation
import SpriteKit

class Deck: SKSpriteNode {
    var currentTexture: SKTexture
    var deckList: [Card] = []
    
    init() {
        for i in 0...14 {
            if i > 0 && i < 13 {
                for _ in 1...4 {
                    deckList.append(Card(cardType: i, place: .deck))
                }
            } else {
                for _ in 1...2 {
                    deckList.append(Card(cardType: i, place: .deck))
                }
            }
        }
        
        deckList.shuffle()
        
        currentTexture = CARD_BACK_TEXTURE
        super.init(texture: currentTexture, color: UIColor.clear, size: currentTexture.size())
        self.name = "Deck"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() -> Card {
        let card = deckList[0]
        deckList.remove(at: 0)
        
        return card
    }
    
    func update() {
        self.texture = SKTexture(imageNamed: "Card_\(deckList.isEmpty ? "placeholder" : "back")")
    }
    
    func printDeck() {
        for card in deckList {
            print(card.type.value)
        }
    }
}
