//
//  GameScene.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    var gameController = GameController()
    private let gap = CGFloat(10)
    var gameViewDelegate: GameViewDelegate?
    private var swipingPlayerCard: Card?
    private var swipingPlayerCardPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(CustomColor.background)
        gameController.setUpGame(scene: self)
        
        positionCardsOnTable()
        addChild(gameController.deck)
        addChild(gameController.discardPile)
        if let topPileCard = gameController.topPileCard {
            addChild(topPileCard)
        }
        
        positionPlayerLabels()
        positionKabooButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Run when touch is detected
        for touch in touches {
            if let card = atPoint(touch.location(in: self)) as? Card,
                card.place != .deck,
                card.place != .pile,
                card.place != .placeholder {
                swipingPlayerCard = card
                swipingPlayerCardPosition = card.position
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let swipingPlayerCard = swipingPlayerCard else { return }
        for touch in touches {
//            let location = touch.location(in: self)
//            if let card = atPoint(location) as? Card, card == swipingPlayerCard {
//                card.position = location
//            }
//            for child in children {
//                if let card = child as? Card, card == swipingPlayerCard {
//                    card.position = touch.location(in: self)
//                }
//            }
            swipingPlayerCard.position = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let card = atPoint(location) as? Card {
                
                if let swipedPlayerCard = swipingPlayerCard, let swipedPlayerCardOriginalPosition = swipingPlayerCardPosition {
                    //if we do move(to: ...) then player can start new moving before finishing called and everything breaks
                    swipedPlayerCard.position = swipedPlayerCardOriginalPosition
                }
                // gameController.discardPile.frame.contains(location),
                
                if card.place == .pile, let swipedPlayerCard = swipingPlayerCard {
                    gameController.snapCard(card: swipedPlayerCard)
                } else if gameController.peekPhase {
                    if touch.tapCount == 1 {
                        gameController.peek(card: card)
                    }
                } else if gameController.spyPhase {
                    if touch.tapCount == 1 {
                        gameController.spy(card: card)
                    }
                } else if gameController.blindSwapPhase {
                    if touch.tapCount == 1 {
                        gameController.blindSwap(withCard: card)
                    }
                } else if gameController.spyAndSwapPhase {
                    if touch.tapCount == 1 {
                        gameController.spyAndSwap(card: card)
                    }
                } else {
                    card.runPickUpAction()
                    
                    if touch.tapCount == 1 {
                        gameController.selectCardOrPerformAction(cardTapped: card)
                    } else if touch.tapCount > 1, gameController.drawnCard != nil && card.place == .pile {
                        gameController.discardDrawnCard()
                    }
                }
            }
            
            
            
            if !gameController.peekPhase && !gameController.spyPhase && !gameController.blindSwapPhase && !gameController.spyAndSwapPhase {
                if atPoint(location) is Deck {
                    if touch.tapCount > 1 && !gameController.deck.deckList.isEmpty {
                        gameController.drawCardFromDeck()
                        if gameController.deck.deckList.isEmpty {
                            gameController.deck.update()
                        }
                    }
                }
                
                if let kabooButton = atPoint(location) as? KabooButton {
                    kabooButton.touch()
                    gameController.callKaboo()
                }
            }
        }
        
        for child in children {
            if let card = child as? Card {
                card.runDropAction()
            }
        }
        
        swipingPlayerCard = nil
        swipingPlayerCardPosition = nil
        
        //        for touch in touches {
        //            let location = touch.location(in: self)
        //            if let card = atPoint(location) as? Card {
        //                card.runDropAction()
        //            }
        //        }
    }
    
    func positionCardsOnTable() {
        for player in self.gameController.players {
            addCards(fromPlayer: player)
        }
    }
    
    func addCards(fromPlayer player: Player) {
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
    
    func positionPlayerLabels() {
        for player in gameController.players {
            addLabel(fromPlayer: player)
        }
    }
    
    func addLabel(fromPlayer player:Player) {
        let gap = CGFloat(15)
        var pointer: CGPoint?
        
        switch player.id {
        case .player1:
            pointer = CGPoint(
                x: frame.midX + player.label.frame.width/2,
                y: player.cards[0].frame.maxY + player.label.rect.frame.height/2 + gap
            )
            
        case .player2:
            pointer = CGPoint(
                x: frame.minX + player.label.rect.frame.width/2 + gap,
                y: player.cards[3].position.y + player.cards[3].frame.width/2 + gap
            )
            
        case .player3:
            pointer = CGPoint(
                x: frame.midX + player.label.frame.width/2,
                y: player.cards[0].frame.minY - player.label.rect.frame.height/2 - gap
            )
            
        default:
            pointer = CGPoint(
                x: frame.maxX - player.label.rect.frame.width/2 - gap,
                y: player.cards[0].position.y + player.cards[0].frame.width/2 + gap
            )
        }
        
        if let pointer = pointer {
            player.label.position = pointer
            addChild(player.label)
        }
    }
    
    func positionKabooButton() {
        let button = KabooButton()
        button.position = CGPoint(x: frame.midX, y: frame.midY - 108)
        addChild(button)
    }
}
