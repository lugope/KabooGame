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
    let deck = Deck()
    let discardPile = DiscardPile()
    var drawnCard: Card?
    
    init() {
        self.players = []
        self.gameScene = nil
    }
    
    func drawCardFromDeck() {
        drawnCard = deck.draw()
        drawnCard!.position = CGPoint(x: gameScene!.frame.midX - CARD_SIZE_WIDTH * 0.6, y: gameScene!.frame.midY)
        gameScene?.addChild(drawnCard!)
    }
    
    func discardDrawnCard() {
        discardPile.pile.insert(drawnCard!, at: 0)
        discardPile.update()
        print("pile:")
        discardPile.printPile()
        drawnCard!.removeFromParent()
        drawnCard = nil
    }
}
