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
        gameController.players = defineDummyPlayers()
        
        positionCardsOnTable()
    }
    
    //Temporary function to delete!!!
    func defineDummyPlayers() -> [Player] {
        let player1 = Player(id: PlayerId.player1, isDeviceHolder: true)
        player1.cards = [
            Card(cardType: 1),
            Card(cardType: 2),
            Card(cardType: 3),
            Card(cardType: 4)
        ]
        
        let player2 = Player(id: .player2, isDeviceHolder: false)
        player2.cards = [
            Card(cardType: 9),
            Card(cardType: 10),
            Card(cardType: 11),
            Card(cardType: 12)
        ]
        
        let player3 = Player(id: .player3, isDeviceHolder: false)
        player3.cards = [
            Card(cardType: 5),
            Card(cardType: 6),
            Card(cardType: 7),
            Card(cardType: 8)
        ]
        
        let player4 = Player(id: .player4, isDeviceHolder: false)
        player4.cards = [
            Card(cardType: 5),
            Card(cardType: 6),
            Card(cardType: 7),
            Card(cardType: 8)
        ]
        
        return [player1, player2, player3, player4]
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
