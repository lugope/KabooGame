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
    var cards: [Card] = [Card(cardType: .card0),
                         Card(cardType: .card1),
                         Card(cardType: .card2),
                         Card(cardType: .card3),
                         Card(cardType: .card4),
                         Card(cardType: .card5),
                         Card(cardType: .card6),
                         Card(cardType: .card7),
                         Card(cardType: .card8),
                         Card(cardType: .card9),
                         Card(cardType: .card10),
                         Card(cardType: .card11),
                         Card(cardType: .card12),
                         Card(cardType: .card13),
                         Card(cardType: .jocker),]
    var deck: [Card] = []
    
    init() {
        for card in cards {
            if card.type.value > 0 && card.type.value < 13 {
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
            print(card.type.value)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
