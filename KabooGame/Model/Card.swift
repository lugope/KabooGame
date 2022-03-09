//
//  Card.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation
import SpriteKit
import SwiftUI

class Card: SKSpriteNode {
    
    let type: CardType
    var place: CardPlace
    var faceUp: Bool = false
    @AppStorage("sfx") var savedSfx = true
    
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
    
    func flip() {
        let flippingDuration: CGFloat = 0.5
        
        let halfTurnEffect = SKAction.scaleX(to: 0, duration: flippingDuration)
        let changeTexture = SKAction.run {
            self.faceUp.toggle()
            self.texture = self.faceUp ? self.type.texture : CARD_BACK_TEXTURE
        }
        let turnBackEffect = SKAction.scaleX(to: 1, duration: flippingDuration)
        let sequence = SKAction.sequence([halfTurnEffect,changeTexture,turnBackEffect])
        
        if savedSfx {
            SoundManager.sharedManager.playSound(sound: "flip", type: "mp3")
        }
        
        run(sequence)
    }
    
    func temporaryFlip() {
        var positionShift: CGFloat = 0
        if self.place == .handPlayer2 {
            positionShift = CARD_SIZE_HEIGHT/2
        } else if self.place == .handPlayer4 {
            positionShift = -CARD_SIZE_HEIGHT/2
        }
        
        let flipCard = SKAction.run { self.flip() }
        let wait = SKAction.wait(forDuration: 2)
        let moveFoward = SKAction.move(by: CGVector(dx: positionShift, dy: 0), duration: 0.3)
        let moveBack = SKAction.move(by: CGVector(dx: -positionShift, dy: 0), duration: 0.3)
        
        let sequence = SKAction.sequence([flipCard, moveFoward, wait, flipCard, moveBack])
        run(sequence)
    }
    
    func rightSnappingAnimation() {
        let growCard = SKAction.scale(by: 2, duration: 0)
        let sizeBack = SKAction.scale(by: 0.5, duration: 0)
        let actionSeq = SKAction.sequence([growCard, sizeBack])
        
        run(actionSeq)
    }
    
    func wrongSnappingAnimation() {
        let initPosition = self.position
        let shakeAmplitude:CGFloat = 10
        let numberOfShakes = 8

        var actionsArray:[SKAction] = []
        for i in 0...numberOfShakes {
            var direction:CGFloat = 1
            if i%2 > 0 {
                direction = -1
            }

            var vector = CGVector()
            if place == .handPlayer1 || place == .handPlayer2 {
                vector = CGVector(dx: shakeAmplitude*direction, dy: 0)
            } else {
                vector = CGVector(dx: 0, dy: shakeAmplitude*direction)
            }

            let shakeAction = SKAction.moveBy(x: vector.dx, y: vector.dy, duration: 0.1)
            shakeAction.timingMode = .easeOut
            actionsArray.append(shakeAction)
        }
        
        actionsArray.append(
            SKAction.move(to: initPosition, duration: 0)
        )
        
        let actionSeq = SKAction.sequence(actionsArray)
        run(actionSeq)
    }
    
    func move(to newLocation: CGPoint, withZRotation zRotation: CGFloat? = nil) {
        self.run(SKAction.move(to: newLocation, duration: 1.5))
        if let zRotation = zRotation {
            self.run(SKAction.rotate(toAngle: zRotation, duration: 1.5))
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
    
    func setHighlighting(_ highlightingType: CardHighlighting) {
        if faceUp {
            texture = highlightingType == .none ? type.texture : type.highlightedTexture
        } else {
            switch highlightingType {
            case .none: texture = CARD_BACK_TEXTURE
            case .purple: texture = CARD_BACK_HIGHLIGHTED_PURPLE_TEXTURE
            case .blue: texture = CARD_BACK_HIGHLIGHTED_BLUE_TEXTURE
            }
        }
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
    
    var highlightedTexture: SKTexture {
        return SKTexture(imageNamed: "Card_" + String(self.rawValue) + "_highlighted")
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

enum CardHighlighting {
    case none
    case purple
    case blue
}

enum CardLevel :CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 150
}
