//
//  GameController.swift
//  KabooGame
//
//  Created by Lucas Pereira on 15/02/22.
//

import SpriteKit
import Foundation
import SwiftUI

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
    
    let haptics = UINotificationFeedbackGenerator()
    @AppStorage("sfx") var savedSfx = true
    @AppStorage("vibration") var savedVibration = true
    
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
        
        if savedSfx {
            SoundManager.sharedManager.playSound(sound: "snap", type: "mp3")
        }
        if savedVibration {
            haptics.notificationOccurred(.success)
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
                        if savedSfx {
                            SoundManager.sharedManager.playSound(sound: "snap", type: "mp3")
                        }
                        if savedVibration {
                            haptics.notificationOccurred(.success)
                        }
                        player.cards.remove(at: cardPositionIndex)
                        discardPile.pile.insert(tempCard, at: 0)
                        discardPile.update()
                        //Clean old card and selections
                        tempCard.removeFromParent()
                        cardSelected = nil
                        drawnCard = nil
                    } else {
                        if savedSfx {
                            SoundManager.sharedManager.playSound(sound: "flip", type: "mp3")
                        }
                        if savedVibration {
                            haptics.notificationOccurred(.error)
                        }
                        card.flip()
                        print("Wrong card! Penalty: 5 points")
                        player.points += 5
                        player.label.score = player.points
                        player.label.updateScoreLabel()
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
            card.temporaryFlip()
            
            peekPhase = false
            finishTurn()
        }
    }
    
    func spy(card: Card) {
        if isOtherPlayerCard(cardPlace: card.place) {
            card.temporaryFlip()
            
            spyPhase = false
            finishTurn()
        }
    }
    
    //MARK: Managing Blind Swap
    func blindSwap(withCard card: Card) {
        print("Blind Swap:")
        if isOtherPlayerCard(cardPlace: card.place) {
            selectCard(card)
            
        } else if card.place.rawValue == currentTurn.rawValue {
            if cardSelected != nil {
                print("performed from \(cardSelected!.type) to \(card.type)")
                
                swapOtherPlayerCardSelectedToPlayer(card: card)
                blindSwapPhase = false
                finishTurn()
            }
        }
    }
    
    func swapOtherPlayerCardSelectedToPlayer(card playerCard: Card) {
        let currentPlayer = players.filter{ $0.id == currentTurn }.first
        let otherPlayer = players.filter { $0.id.rawValue == cardSelected!.place.rawValue }.first
        
        let tempCardPosition = cardSelected!.position
        let tempCardzRotation = cardSelected!.zRotation
        let tempCardPlace = cardSelected!.place
        
        if let currentPlayerCardPositionIndex = positionInCurrentPlayerHand(ofCard: playerCard){
            if let otherPlayerCardPositionIndex = positionInPlayerHand(ofCard: cardSelected!){
                
                // Move card selected from other player to current player's hand
                cardSelected!.move(to: playerCard.position, withZRotation: playerCard.zRotation)
                cardSelected!.place = playerCard.place
                currentPlayer!.cards[currentPlayerCardPositionIndex] = cardSelected!
                
                // Move card from plyer's hand to other player
                playerCard.move(to: tempCardPosition, withZRotation: tempCardzRotation)
                playerCard.place = tempCardPlace
                otherPlayer!.cards[otherPlayerCardPositionIndex] = playerCard
            }
        }
        
        cardSelected = nil
    }
    
    func isOtherPlayerCard(cardPlace: CardPlace) -> Bool {
        if cardPlace != .deck &&
            cardPlace != .pile &&
            cardPlace != .placeholder &&
            cardPlace.rawValue != currentTurn.rawValue {
            
            return true
        }
        return false
    }
    
    //MARK: Managing Spy n Swap
    func spyAndSwap(card: Card) {
        print("Spy and swap:")
        
        if let cardSelected = cardSelected {
            if card.place.rawValue == currentTurn.rawValue {
                cardSelected.flip()
                swapOtherPlayerCardSelectedToPlayer(card: card)
                spyAndSwapPhase = false
                finishTurn()
                
            } else if card == cardSelected {
                cardSelected.flip()
                finishTurn()
            }
            
        } else {
            if isOtherPlayerCard(cardPlace: card.place) {
                card.flip()
                cardSelected = card
                print("Card Selected \(card.type)")
            }
        }
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
        if savedSfx {
            SoundManager.sharedManager.playSound(sound: "coin", type: "mp3")
        }
        if savedVibration {
            haptics.notificationOccurred(.success)
        }
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
            for player in players {
                for card in player.cards {
                    player.points += card.type.value
                }
            }
            gameScene?.gameViewDelegate?.finishGame(players: players)
        }
    }
}

enum Phase {
    case peekPhase, spyPhase, blindSwapPhase, spyAndSwapPhase
}
