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
        
        topPileCard = deck.draw()
        if let topPileCard = topPileCard {
            topPileCard.place = .pile
            if !topPileCard.faceUp { topPileCard.flip() }
            discardPile.pile.append(topPileCard)
            discardPile.update()
            
            topPileCard.position = deck.position
            topPileCard.move(to: discardPile.position)
        }
        
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
            
            if currentTurn == player.id {
                player.label.isCurrentTurn = true
            }
        }
    }
    
    //MARK: Managing Deck
    func drawCardFromDeck() {
        if drawnCard == nil {
            drawnCard = deck.draw()
            drawnCard!.position = deck.position
            drawnCard!.place = .deck
            
            gameScene?.addChild(drawnCard!)
            drawnCard!.flip()
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
    
    //MARK: Managing Swap Action
    func selectCardOrPerformAction(cardTapped: Card) {
        if cardTapped.place == .deck || (cardTapped.place == .pile && drawnCard == nil) {
            for player in players {
                if player.id == currentTurn {
                    for card in player.cards {
                        card.setHighlighting(cardTapped.place == .deck ? .blue : .purple)
                    }
                }
            }
            if cardTapped.place == .deck {
                topPileCard?.setHighlighting(.blue)
            }
            cardSelected = cardTapped
            print("Card Selected: \(cardSelected!.type.rawValue)")
            
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
        if let cardPositionIndex = positionInCurrentPlayerHand(ofCard: card) {
            if let cardToAdd = cardSelected {
                
                for player in players {
                    if player.id == currentTurn {
                        
                        let tempCard = player.cards[cardPositionIndex]
                        let cardToAddPlace = cardToAdd.place
                        
                        // Put card selected in players hand
                        cardToAdd.move(to: tempCard.position, withZRotation: tempCard.zRotation)
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
                        topPileCard?.move(to: discardPile.position, withZRotation: discardPile.zRotation)
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
    
    func selectCard(_ card: Card) {
        self.cardSelected = card
        print("Card Selected: \(cardSelected!.type.rawValue)")
    }
    
    func snapCard(card: Card) {
        if let cardPositionIndex = positionInPlayerHand(ofCard: card) {
            for player in players {
                if player.id.rawValue == card.place.rawValue {
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
                        player.points += 5
                        print(player.points)
                        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            card.flip()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Peek and Spy
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
    
    //MARK: Managing Blind Swap
    func selectCardOrPerformBlindSwap(withCard card: Card) {
        print("Blind Swap:")
        if card.place.rawValue == currentTurn.rawValue {
            selectCard(card)
            
            
        } else if card.place != .deck && card.place != .pile {
            if cardSelected != nil {
                print("performed from \(cardSelected!.type) to \(card.type)")
                
                blindSwap(by: card)
                blindSwapPhase = false
                finishTurn()
            }
        }
    }
    
    func blindSwap(by otherPlayerCard:Card) {
        let currentPlayer = players.filter{ $0.id == currentTurn }.first
        let otherPlayer = players.filter { $0.id.rawValue == otherPlayerCard.place.rawValue }.first
        
        if let cardSelected = cardSelected {
            if let currentPlayerCardPositionIndex = positionInCurrentPlayerHand(ofCard: cardSelected){
                if let otherPlayerCardPositionIndex = positionInPlayerHand(ofCard: otherPlayerCard) {
                    
                    let tempCardPosition = cardSelected.position
                    let tempCardzRotation = cardSelected.zRotation
                    let tempCardPlace = cardSelected.place
                    
                    //Move card selected from current player to other player's hand
                    cardSelected.move(to: otherPlayerCard.position, withZRotation: otherPlayerCard.zRotation)
                    cardSelected.place = otherPlayerCard.place
                    otherPlayer?.cards[otherPlayerCardPositionIndex] = cardSelected
                    
                    //Move other player's card to current player hand
                    otherPlayerCard.move(to: tempCardPosition, withZRotation: tempCardzRotation)
                    otherPlayerCard.place = tempCardPlace
                    currentPlayer?.cards[currentPlayerCardPositionIndex] = otherPlayerCard
                }
            }
        }
        
        cardSelected = nil
    }
    
    func spyAndSwap(card: Card) {
        print("Spy and swap")
        spyAndSwapPhase = false
        finishTurn()
    }
    
    func positionInCurrentPlayerHand(ofCard card: Card) -> Int? {
        for player in players {
            if player.id == currentTurn {
                return player.cards.firstIndex(of: card)
            }
        }
        
        return nil
    }
    
    func positionInPlayerHand(ofCard card:Card) -> Int? {
        for player in players {
            if player.id.rawValue == card.place.rawValue {
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
        for player in players {
            if player.id == currentTurn {
                player.label.isCurrentTurn = false
                
                for card in player.cards {
                    card.setHighlighting(.none)
                }
            }
        }
        topPileCard?.setHighlighting(.none)
        
        currentTurn = currentTurn.next()
        players.filter {
            $0.id == currentTurn
        }.first?.label.isCurrentTurn = true
        print("Now it's \(currentTurn) turn!!!")
        
        if currentTurn == playerCalledKaboo {
            gameScene?.gameViewDelegate?.finishGame(players: players)
        }
    }
}

enum Phase {
    case peekPhase, spyPhase, blindSwapPhase, spyAndSwapPhase
}
