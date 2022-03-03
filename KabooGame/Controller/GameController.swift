//
//  GameController.swift
//  KabooGame
//
//  Created by Lucas Pereira on 15/02/22.
//

import SpriteKit
import Foundation

class GameController {
    var gameScene: GameScene?
    var players: [Player]
    var currentTurn: PlayerId = .player1
    var playerCalledKaboo: PlayerId?
    
    var drawnCard: Card?
    var topPileCard: Card?
    var cardSelected: Card?
    
    let deck = Deck()
    let discardPile = DiscardPile()
    
    var peekPhase = false
    var spyPhase = false
    var blindSwapPhase = false
    var spyAndSwapPhase = false
    
    init() {
        self.players = []
        self.gameScene = nil
    }
    
    //MARK: Setting Up Game
    func setUpGame(scene: GameScene) {
        gameScene = scene
        
        deck.position = CGPoint(
            x: scene.frame.midX - CARD_SIZE_WIDTH * 0.6,
            y: scene.frame.midY
        )
        discardPile.position = CGPoint(
            x: scene.frame.midX + CARD_SIZE_WIDTH * 0.6,
            y: scene.frame.midY
        )
        
        let firstPileCard = deck.draw()
        firstPileCard.place = .pile
        if !firstPileCard.faceUp { firstPileCard.flip() }
        discardPile.pile.append(firstPileCard)
        discardPile.update()
        
        topPileCard = firstPileCard
        topPileCard?.move(to: discardPile.position)
        //topPileCard?.position = discardPile.position
        
        // Temp variable: Delete latter
        let dummyPlayerList = [
            Player(id: .player1, isDeviceHolder: true, name: "Dude"),
            Player(id: .player2, isDeviceHolder: false, name: "Kate"),
            Player(id: .player3, isDeviceHolder: false, name: "Carl"),
            Player(id: .player4, isDeviceHolder: false, name: "Peter")]
        players = dummyPlayerList
        
        for player in players {
            for _ in 0...3 {
                let card = deck.draw()
                if let place = CardPlace(rawValue: player.id.rawValue) {
                    card.place = place
                } else {
                    card.place = CardPlace.placeholder
                }
                
                player.cards.append(card)
            }
        }
    }
    
    //MARK: Managing Deck
    func drawCardFromDeck() {
        if drawnCard == nil {
            drawnCard = deck.draw()
            drawnCard!.move(to: CGPoint(x: gameScene!.frame.midX - CARD_SIZE_WIDTH * 0.75, y: gameScene!.frame.midY))
            //drawnCard!.position = CGPoint(x: gameScene!.frame.midX - CARD_SIZE_WIDTH * 0.75, y: gameScene!.frame.midY)
            drawnCard!.place = .deck
            gameScene?.addChild(drawnCard!)
            drawnCard!.flip()
            cardSelected = drawnCard!
        }
    }
    
    func discardDrawnCard() {
        let tempCard = drawnCard
        drawnCard!.removeFromParent()
        topPileCard?.removeFromParent()
        topPileCard = nil
        discardPile.pile.insert(tempCard!, at: 0)
        discardPile.update()
        tempCard?.place = .pile
        topPileCard = tempCard
        
        topPileCard?.move(to: discardPile.position)
        //        topPileCard?.position = discardPile.position
        topPileCard?.zRotation = discardPile.zRotation
        gameScene?.addChild(topPileCard!)
        topPileCard?.runDropAction()
        switch topPileCard!.type.value {
        case 7...8:
            peekPhase = true
        case 9...10:
            spyPhase = true
        case 11...12:
            blindSwapPhase = true
        case 13:
            spyAndSwapPhase = true
        default:
            print("No action")
            finishTurn()
        }
        drawnCard = nil
        cardSelected = nil
        //        print("pile:")
        //        discardPile.printPile()
    }
    
    //MARK: Managing Swipe Action
    func selectCardOrPerformAction(cardTapped: Card) {
        if cardTapped.place == .deck || cardTapped.place == .pile {
            cardSelected = cardTapped
            print("Card Selected: \(cardSelected?.type.rawValue)")
            
        }
        if cardSelected != nil && isCurrentTurnPlayersCard(cardTapped) {
            swapCardSelectedToPlayersCard(cardTapped)
        }
    }
    
    func isCurrentTurnPlayersCard(_ card: Card) -> Bool {
        if card.place.rawValue == currentTurn.rawValue {
            return true
        }
        return false
    }
    
    func swapCardSelectedToPlayersCard(_ card: Card) {
        if let cardPositionIndex = positionInCurrentPlayerHand(card: card) {
            if let cardToAdd = cardSelected {
                
                for player in players {
                    if player.id == currentTurn {
                        
                        let tempCard = player.cards[cardPositionIndex]
                        let cardToAddPlace = cardToAdd.place
                        
                        // Put card selected in players hand
                        cardToAdd.move(to: tempCard.position)
                        //                        cardToAdd.position = tempCard.position
                        cardToAdd.zRotation = tempCard.zRotation
                        cardToAdd.place = tempCard.place
                        if cardToAdd.faceUp {
                            cardToAdd.flip()
                        }
                        player.cards[cardPositionIndex] = cardToAdd
                        
                        // When card come from the deck
                        if cardToAddPlace == .deck {
                            //Remove old top pile card from screen
                            topPileCard?.removeFromParent()
                            // When card come from the pile
                        } else {
                            //Take old top pile card from pile list
                            discardPile.pop()
                        }
                        topPileCard = nil
                        
                        //Add changed card to pile
                        discardPile.pile.insert(tempCard, at: 0)
                        discardPile.update()
                        tempCard.place = .pile
                        //Put changed card to the top of the pile
                        topPileCard = tempCard
                        topPileCard?.move(to: discardPile.position)
                        //                        topPileCard?.position = discardPile.position
                        topPileCard?.zRotation = discardPile.zRotation
                        topPileCard?.runDropAction()
                        if !tempCard.faceUp {
                            topPileCard?.flip()
                        }
                        
                        //Clear selections
                        cardSelected = nil
                        drawnCard = nil
                        
                        
                        finishTurn()
                        return
                    }
                }
            }
        }
    }
    
    func snapCard(card: Card) {
        if let cardPositionIndex = positionInCurrentPlayerHand(card: card) {
            for player in players {
                if player.id == currentTurn {
                    // Put card selected in players hand
                    let tempCard = player.cards[cardPositionIndex]
                    
                    //Add changed card to pile
                    if discardPile.pile[0].type.value == player.cards[cardPositionIndex].type.value {
                        player.cards.remove(at: cardPositionIndex)
                        discardPile.pile.insert(tempCard, at: 0)
                        discardPile.update()
                        //Clean old card and selections
                        tempCard.removeFromParent()
                        cardSelected = nil
                        drawnCard = nil
                    } else {
                        card.flip()
                        print("Wrong card! Penalty: 5 points")
                        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            card.flip()
                        }
                    }
                }
            }
        }
    }
    
    var actionTimer: Timer?
    var actionTimerCount = 0
    
    func peek(card: Card) {
        if card.place.rawValue == currentTurn.rawValue {
            card.flip()
            actionTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                if self.actionTimerCount == 1 {
                    card.flip()
                } else if self.actionTimerCount == 2 {
                    self.actionTimer?.invalidate()
                    self.actionTimer = nil
                    return
                }
                self.actionTimerCount += 1
            }
            actionTimer?.fire()
            peekPhase = false
            finishTurn()
        }
        
    }
    
    func spy(card: Card) {
        if card.place.rawValue != currentTurn.rawValue && card.place != .pile && card.place != .deck && card.place != .placeholder {
            card.flip()
            actionTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                if self.actionTimerCount == 1 {
                    card.flip()
                } else if self.actionTimerCount == 2 {
                    self.actionTimer?.invalidate()
                    self.actionTimer = nil
                    return
                }
                self.actionTimerCount += 1
            }
            actionTimer?.fire()
            spyPhase = false
            finishTurn()
        }
    }
    
    func blindSwap(card: Card) {
        print("Blind Swap")
        blindSwapPhase = false
        finishTurn()
    }
    
    func spyAndSwap(card: Card) {
        print("Spy and swap")
        spyAndSwapPhase = false
        finishTurn()
    }
    
    func positionInCurrentPlayerHand(card: Card) -> Int? {
        for player in players {
            if player.id == currentTurn {
                return player.cards.firstIndex(of: card)
            }
        }
        
        return nil
    }
    
    func callKaboo() {
        guard playerCalledKaboo == nil else { return }
        playerCalledKaboo = currentTurn
        finishTurn()
    }
    
    func finishTurn() {
        currentTurn = currentTurn.next()
        if currentTurn == playerCalledKaboo {
            print("finish a game")
        }
    }
}