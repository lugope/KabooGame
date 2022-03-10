//
//  GameScene.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI
import AVFoundation

class GameScene: SKScene {
    @AppStorage("sfx") var savedSfx = true
    
    var gameController = GameController()
    var gameViewDelegate: GameViewDelegate?
    
    private let gap = CGFloat(10)
    
    private var swipingPlayerCard: Card?
    private var swipingPlayerCardPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(CustomColor.gameBackground)
        gameController.setUpGame(scene: self)
        
        positionCardsOnTable()
        addChild(gameController.deck)
        addChild(gameController.discardPile)
        if let topPileCard = gameController.topPileCard {
            addChild(topPileCard)
        }
        
        positionPlayerLabels()
        positionKabooButton()
        positionExitButton()
        
        if savedSfx {
            SoundManager.sharedManager.playSound(sound: "deal", type: "mp3")
        }
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
                
                //Handle snapping action
                if let swipedPlayerCard = swipingPlayerCard {
                    let allNodes = nodes(at: location)
                    for node in allNodes {
                        if let card = node as? Card {
                            if card.place == .pile {
                                gameController.snapCard(card: swipedPlayerCard)
                                break
                            }
                        }
                    }
                    
                    self.swipingPlayerCard = nil
                }
                  
                // Handle card effect actions and default card swapping
                if gameController.peekPhase {
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
            
            // Handle drawn from deck and call Kaboo
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
            
            if atPoint(location) is ExitButton {
                self.gameViewDelegate?.exitGame()
            }
        }
        
        for child in children {
            if let card = child as? Card {
                card.runDropAction()
            }
        }
        
        swipingPlayerCard = nil
        swipingPlayerCardPosition = nil
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
        let gap: CGFloat = 15
        let deckPosition = gameController.deck.position
        let deckHeight = gameController.deck.size.height
        
        button.position = CGPoint(
            x: frame.midX,
            y: deckPosition.y + deckHeight/2 + button.size.height/2 + gap
        )
        addChild(button)
    }
    
    func positionExitButton() {
        let button = ExitButton()
        let labelReference = gameController.players.filter {
            $0.id == .player1
        }.first?.label.position
        let cardReference = gameController.players.filter {
            $0.id == .player1
        }.first?.cards[0].position
        
        if let labelReference = labelReference {
            if let cardReference = cardReference {
                button.position = CGPoint(
                    x: cardReference.x,
                    y: labelReference.y
                )
                addChild(button)
            }
        }
    }
}
