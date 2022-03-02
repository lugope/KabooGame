//
//  Card.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    
    let type: CardType
    var place: CardPlace
    var faceUp: Bool = false
    
    init(cardType: CardType, place: CardPlace) {
        self.type = cardType
        self.place = place
        
        super.init(
            texture: faceUp ? self.type.texture : CARD_BACK_TEXTURE,
            color: UIColor.clear,
            size: CGSize(width: CARD_SIZE_WIDTH, height: CARD_SIZE_HEIGHT)
        )
        
        self.name = "Card"
    }
    
    convenience init(cardType: Int, place: CardPlace) {
        let type: CardType = CardType(rawValue: cardType) ?? CardType.placeholder
        self.init(cardType: type, place: place)
    }
    
    var flippingTimerCount = 0
    var flippingTimer: Timer?
    
    func flip() {
        guard flippingTimerCount == 0 else { return }
        let flippingDuration: CGFloat = 2
        self.run(SKAction.scaleX(to: 0, duration: flippingDuration / 2))
        flippingTimer = Timer.scheduledTimer(withTimeInterval: flippingDuration / 2, repeats: true) { _ in
            if self.flippingTimerCount == 1 {
                if self.faceUp {
                    self.texture = CARD_BACK_TEXTURE
                } else {
                    self.texture = self.type.texture
                }
                
                self.faceUp.toggle()
                self.run(SKAction.scaleX(to: 1, duration: flippingDuration / 2))
            } else if self.flippingTimerCount == 2 {
                self.flippingTimerCount = 0
                self.flippingTimer?.invalidate()
                self.flippingTimer = nil
                return
            }
            self.flippingTimerCount += 1
        }
        
        self.flippingTimer?.fire()
    }
    
    func move(to newLocation: CGPoint, withZRotation zRotation: CGFloat? = nil) {
        self.run(SKAction.move(to: newLocation, duration: 1.5))
        if let zRotation = zRotation {
            self.run(SKAction.rotate(byAngle: zRotation, duration: 1.5))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runPickUpAction() {
        self.zPosition = CardLevel.moving.rawValue
        self.removeAction(forKey: "drop")
        self.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup")
    }
    
    func runDropAction() {
        self.zPosition = CardLevel.board.rawValue
        self.removeAction(forKey: "pickup")
        self.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
    }
}

enum CardType: Int {
    case card0 = 0, card1, card2, card3, card4, card5, card6, card7, card8, card9, card10, card11, card12, card13, jocker, placeholder
    
    var texture: SKTexture {
        if self == CardType.placeholder {
            return CARD_PLACEHOLDER_TEXTURE
            
        } else {
            let textureName = "Card_" + String(self.rawValue)
            return SKTexture(imageNamed: textureName)
        }
    }
    
    var value: Int {
        if self.rawValue <= 13 {
            return self.rawValue
            
        } else if self == .jocker  {
            return -1
            
        } else {
            return 0
        }
    }
}

enum CardPlace: Int {
    case handPlayer1 = 0, handPlayer2, handPlayer3, handPlayer4, deck, pile, placeholder
}

enum CardLevel :CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 150
}
