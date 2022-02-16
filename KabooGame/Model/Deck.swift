//
//  Deck.swift
//  KabooGame
//
//  Created by Danil Masnaviev on 15/02/22.
//

import Foundation
import SpriteKit

class Deck: SKSpriteNode {
    let backTexture: SKTexture
    var cards: [Card] = [Card(cardId: 0),
                         Card(cardId: 1),
                         Card(cardId: 2),
                         Card(cardId: 3),
                         Card(cardId: 4),
                         Card(cardId: 5),
                         Card(cardId: 6),
                         Card(cardId: 7),
                         Card(cardId: 8),
                         Card(cardId: 9),
                         Card(cardId: 10),
                         Card(cardId: 11),
                         Card(cardId: 12),
                         Card(cardId: 13),
                         Card(cardId: 14)]
    var deck: [Card] = []
    
    init() {
        for card in cards {
            if card.cardId > 0 && card.cardId < 13 {
                for _ in 1...4 {
                    deck.append(card)
                }
            } else {
                for _ in 1...2 {
                    deck.append(card)
                }
            }
        }
        deck.shuffle()
        
        backTexture = SKTexture(imageNamed: "Card_back")
        
        super.init(texture: backTexture, color: UIColor.clear, size: backTexture.size())
        self.name = "Deck"
    }
    
    func draw() -> Card {
        let card = deck[0]
        deck.remove(at: 0)
        
        return card
    }
    
    func printDeck() {
        for card in deck {
            print(card.pointsValue)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
