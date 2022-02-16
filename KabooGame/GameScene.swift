//
//  GameScene.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit

enum CardLevel :CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 150
}

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        
        let deck = Deck()
        let discardPile = DiscardPile()
        
        discardPile.pile.append(deck.draw())
        discardPile.update()
        
        let card1 = Card(cardType: .card2)
        let card2 = Card(cardType: .card8)
        let card3 = Card(cardType: .jocker)
        let card4 = Card(cardType: .card12)
        
        deck.position = CGPoint(x: frame.midX - 40, y: frame.midY)
        discardPile.position = CGPoint(x: frame.midX + 40, y: frame.midY)
        
        card1.position = CGPoint(x: frame.midX - 120, y: frame.minY + 100)
        card2.position = CGPoint(x: frame.midX - 40, y: frame.minY + 100)
        card3.position = CGPoint(x: frame.midX + 40, y: frame.minY + 100)
        card4.position = CGPoint(x: frame.midX + 120, y: frame.minY + 100)
        
        addChild(deck)
        addChild(discardPile)
        
        addChild(card1)
        addChild(card2)
        addChild(card3)
        addChild(card4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Run when touch is detected
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                card.zPosition = CardLevel.moving.rawValue
                card.removeAction(forKey: "drop")
                card.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup")
                if touch.tapCount > 1 {
                    card.flip()
                }
            }
            
            if let discardPile = atPoint(location) as? DiscardPile {
                if touch.tapCount > 1 {
                    discardPile.printPile()
                }
            }
            
            if let deck = atPoint(location) as? Deck {
                if touch.tapCount > 1 {
                    deck.printDeck()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)           // 1
            if let card = atPoint(location) as? Card {        // 2
                card.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                card.zPosition = CardLevel.board.rawValue
                card.removeAction(forKey: "pickup")
                card.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                card.removeFromParent()
                addChild(card)
            }
        }
    }
}
