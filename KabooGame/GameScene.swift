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
    case enlarged = 200
}


class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let card1 = Card(cardType: 2)
        let card2 = Card(cardType: 11)
        let card3 = Card(cardType: 8)
        let card4 = Card(cardType: 14)
        let opponentCard1 = Card(cardType: 1)
        let opponentCard2 = Card(cardType: 0)
        let opponentCard3 = Card(cardType: 0)
        let opponentCard4 = Card(cardType: 0)
        let opponentCard5 = Card(cardType: 0)
        let opponentCard6 = Card(cardType: 0)
        let opponentCard7 = Card(cardType: 0)
        let opponentCard8 = Card(cardType: 0)
        let opponentCard9 = Card(cardType: 0)
        let opponentCard10 = Card(cardType: 0)
        let opponentCard11 = Card(cardType: 0)
        let opponentCard12 = Card(cardType: 0)
        
        
        card1.position = CGPoint(x: frame.midX - 120, y: frame.minY + 100)
        card2.position = CGPoint(x: frame.midX - 40, y: frame.minY + 100)
        card3.position = CGPoint(x: frame.midX + 40, y: frame.minY + 100)
        card4.position = CGPoint(x: frame.midX + 120, y: frame.minY + 100)
        
        opponentCard1.position = CGPoint(x: frame.midX - 120, y: frame.maxY - 40)
        opponentCard2.position = CGPoint(x: frame.midX - 40, y: frame.maxY - 40)
        opponentCard3.position = CGPoint(x: frame.midX + 40, y: frame.maxY - 40)
        opponentCard4.position = CGPoint(x: frame.midX + 120, y: frame.maxY - 40)
        
        opponentCard5.position = CGPoint(x: frame.minX, y: frame.midY + 140)
        opponentCard5.zRotation = CGFloat.pi / 2
        opponentCard6.position = CGPoint(x: frame.minX, y: frame.midY + 60)
        opponentCard6.zRotation = CGFloat.pi / 2
        opponentCard7.position = CGPoint(x: frame.minX, y: frame.midY - 20)
        opponentCard7.zRotation = CGFloat.pi / 2
        opponentCard8.position = CGPoint(x: frame.minX, y: frame.midY - 100)
        opponentCard8.zRotation = CGFloat.pi / 2
        
        opponentCard9.position = CGPoint(x: frame.maxX, y: frame.midY + 140)
        opponentCard9.zRotation = CGFloat.pi / 2
        opponentCard10.position = CGPoint(x: frame.maxX, y: frame.midY + 60)
        opponentCard10.zRotation = CGFloat.pi / 2
        opponentCard11.position = CGPoint(x: frame.maxX, y: frame.midY - 20)
        opponentCard11.zRotation = CGFloat.pi / 2
        opponentCard12.position = CGPoint(x: frame.maxX, y: frame.midY - 100)
        opponentCard12.zRotation = CGFloat.pi / 2
        
        addChild(card1)
        addChild(card2)
        addChild(card3)
        addChild(card4)
        addChild(opponentCard1)
        addChild(opponentCard2)
        addChild(opponentCard3)
        addChild(opponentCard4)
        addChild(opponentCard5)
        addChild(opponentCard6)
        addChild(opponentCard7)
        addChild(opponentCard8)
        addChild(opponentCard9)
        addChild(opponentCard10)
        addChild(opponentCard11)
        addChild(opponentCard12)
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
