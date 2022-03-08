//
//  TutorialScene.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI

class TutorialScene: SKScene {
    private var tutorialController = TutorialController()
    private let gap = CGFloat(10)
    private var step = 0
    private var swipingPlayerCard: Card?
    private var swipingPlayerCardPosition: CGPoint?
    var tutorialScreenDelegate: TutorialScreenDelegate?
    private var firstConfiguring = true
    
    override func didMove(to view: SKView) {
        guard firstConfiguring else { return }
        tutorialController.tutorialScreenDelegate = tutorialScreenDelegate
        self.backgroundColor = UIColor(CustomColor.background)
        
        tutorialController.setUpGame(scene: self)
        positionCardsOnTable()
        addChild(tutorialController.deck)
        addChild(tutorialController.discardPile)
        if let topPileCard = tutorialController.topPileCard {
            addChild(topPileCard)
        }
        
        positionPlayerLabels()
        positionKabooButton()
        firstConfiguring = false
    }
    
    func finishStep() {
        self.isUserInteractionEnabled = false
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.step += 1
            self.isUserInteractionEnabled = true
            self.tutorialScreenDelegate?.finishStep(self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Run when touch is detected
        guard step == 4 || step > 5 else { return }
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
        guard let swipingPlayerCard = swipingPlayerCard, (step == 4 || step > 5) else { return }
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
                    tutorialController.snapCard(card: swipedPlayerCard)
                    if step == 4 {
                        finishStep()
                    }
                } else if tutorialController.peekPhase, step == -1 {
                    if touch.tapCount == 1 {
                        tutorialController.peek(card: card)
                    }
                } else if tutorialController.spyPhase, step == -1 {
                    if touch.tapCount == 1 {
                        tutorialController.spy(card: card)
                    }
                } else if tutorialController.blindSwapPhase, step == -1 {
                    if touch.tapCount == 1 {
                        tutorialController.blindSwap(withCard: card)
                    }
                } else if tutorialController.spyAndSwapPhase, step == -1 {
                    if touch.tapCount == 1 {
                        tutorialController.spyAndSwap(card: card)
                    }
                } else {
                    card.runPickUpAction()
                    
                    if touch.tapCount == 1, (step == 0 || step == 2 || (step == 3 && card.place == .deck) || step > 5) {
                        if card.place == .handPlayer1, step == 0 {
                            finishStep()
                        } else if card.place == .handPlayer2, step == 2 {
                            finishStep()
                        }
                        tutorialController.selectCardOrPerformAction(cardTapped: card)
                    } else if touch.tapCount > 1, tutorialController.drawnCard != nil, card.place == .pile, (step == 3 || step > 5) {
                        if step == 3 {
                            finishStep()
                        }
                        tutorialController.discardDrawnCard()
                    }
                }
            }
            
            
            
            if !tutorialController.peekPhase && !tutorialController.spyPhase && !tutorialController.blindSwapPhase && !tutorialController.spyAndSwapPhase {
                if atPoint(location) is Deck {
                    if touch.tapCount > 1 && !tutorialController.deck.deckList.isEmpty, (step == 1 || step == 3 || step > 5) {
                        if step == 1 {
                            finishStep()
                        }
                        tutorialController.drawCardFromDeck()
                        if tutorialController.deck.deckList.isEmpty {
                            tutorialController.deck.update()
                        }
                    }
                }
                
                if let kabooButton = atPoint(location) as? KabooButton, step >= 5 {
                    if step == 5 {
                        finishStep()
                        kabooButton.touch()
                        tutorialController.callKaboo()
                    }
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
        for player in self.tutorialController.players {
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
        for player in tutorialController.players {
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
