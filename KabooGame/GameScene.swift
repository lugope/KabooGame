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
    let gap = CGFloat(10)

    
    override func didMove(to view: SKView) {
        //MARK: Game setup
        gameController.gameScene = self
        
        gameController.discardPile.pile.append(gameController.deck.draw())
        gameController.discardPile.update()
        
        gameController.deck.position = CGPoint(x: frame.midX - CARD_SIZE_WIDTH * 0.6, y: frame.midY)
        gameController.discardPile.position = CGPoint(x: frame.midX + CARD_SIZE_WIDTH * 0.6, y: frame.midY)
        
        addChild(gameController.deck)
        addChild(gameController.discardPile)
        
        
        let playerList = [
            Player(id: .player1, isDeviceHolder: true),
            Player(id: .player2, isDeviceHolder: false),
            Player(id: .player3, isDeviceHolder: false),
            Player(id: .player4, isDeviceHolder: false)]
        
        for player in playerList {
            gameController.players.append(player)
        }
        
        for player in gameController.players {
            for _ in 0...3 {
                player.cards.append(gameController.deck.draw())
            }
        }
        for player in gameController.players {
            print(player.id)
            for card in player.cards {
                print(card.type.value)
            }
        }
        
        print("Deck:")
        gameController.deck.printDeck()
        positionCardsOnTable()
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
                if touch.tapCount > 1 && !gameController.deck.deckList.isEmpty {
                    gameController.drawCardFromDeck()
                    if gameController.deck.deckList.isEmpty {
                        gameController.deck.update()
                    }
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
