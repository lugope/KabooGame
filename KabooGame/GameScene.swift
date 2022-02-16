//
//  GameScene.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI

enum CardLevel :CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 150
}

class GameScene: SKScene {
    
    var gameController = GameController()
    
    override func didMove(to view: SKView) {
        //MARK: Game setup
        gameController.gameScene = self
        gameController.discardPile.pile.append(gameController.deck.draw())
        gameController.discardPile.update()
        
        gameController.deck.printDeck()
        
        let card1 = Card(cardType: .card2)
        let card2 = Card(cardType: .card8)
        let card3 = Card(cardType: .jocker)
        let card4 = Card(cardType: .card12)
        
        gameController.deck.position = CGPoint(x: frame.midX - 40, y: frame.midY)
        gameController.discardPile.position = CGPoint(x: frame.midX + 40, y: frame.midY)
        
        card1.position = CGPoint(x: frame.midX - 120, y: frame.minY + 100)
        card2.position = CGPoint(x: frame.midX - 40, y: frame.minY + 100)
        card3.position = CGPoint(x: frame.midX + 40, y: frame.minY + 100)
        card4.position = CGPoint(x: frame.midX + 120, y: frame.minY + 100)
        
        addChild(gameController.deck)
        addChild(gameController.discardPile)
        
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
            
            if atPoint(location) is Deck {
                if touch.tapCount > 1 {
                    gameController.drawCardFromDeck()
                }
            }
            
            if atPoint(location) is DiscardPile {
                if touch.tapCount > 1 {
                    if gameController.drawnCard != nil {
                        gameController.discardDrawnCard()
                    }
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
    
    func positionCardsOnTable() {
        for player in self.gameController.players {
            positionCards(fromPlayer: player)
        }
    }
    
    func positionCards(fromPlayer player: Player) {
        let gap = CGFloat(10)
        
        switch player.id {
        case PlayerId.player1:
            var pointer = CGPoint(
                x: frame.midX - (CARD_SIZE_WIDTH * 1.5) - (gap * 1.5),
                y: frame.minY + (CARD_SIZE_HEIGHT * 0.9)
            )
            
            for card in player.cards {
                card.position = pointer
                addChild(card)
                //Move pointer
                pointer = CGPoint(x: pointer.x + CARD_SIZE_WIDTH + gap, y: pointer.y)
            }
        
        case PlayerId.player2:
            var pointer = CGPoint(
                x: frame.minX,
                y: frame.midY - CARD_SIZE_WIDTH * 1.5 - (gap * 1.5)
            )

            for card in player.cards {
                card.position = pointer
                card.zRotation = -CGFloat.pi / 2
                addChild(card)
                //Move pointer
                pointer = CGPoint(x: pointer.x, y: pointer.y + CARD_SIZE_WIDTH + gap)
            }
            
        case PlayerId.player3:
            var pointer = CGPoint(
                x: frame.midX - CARD_SIZE_WIDTH * 1.5 - (gap * 1.5),
                y: frame.maxY - CARD_SIZE_HEIGHT * 0.9
            )
            
            for card in player.cards {
                card.position = pointer
                addChild(card)
                //Move pointer
                pointer = CGPoint(x: pointer.x + CARD_SIZE_WIDTH + gap, y: pointer.y)
            }
            
        default:
            var pointer = CGPoint(
                x: frame.maxX,
                y: frame.midY + CARD_SIZE_WIDTH * 1.5 + (gap * 1.5)
            )

            for card in player.cards {
                card.position = pointer
                card.zRotation = CGFloat.pi / 2
                addChild(card)
                //Move pointer
                pointer = CGPoint(x: pointer.x, y: pointer.y - CARD_SIZE_WIDTH - gap)
            }
        }
    }
}
