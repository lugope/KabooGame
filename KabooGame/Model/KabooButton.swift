//
//  KabooButton.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 02/03/22.
//

import Foundation
import SpriteKit
import SwiftUI

class KabooButton: SKSpriteNode {
    var isKabooActive: Bool = false
    
    @AppStorage("sfx") var savedSfx = true
    @AppStorage("vibration") var savedVibration = true
    
    init() {
        super.init(texture: SKTexture(imageNamed: "kabooButtonUp"), color: .clear, size: .init(width: 72, height: 72))
        name = "KabooButton"
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touch() {
        let flippingDuration: CGFloat = 0.5
        
        if !isKabooActive {
            self.isKabooActive = false
            let halfTurnEffect = SKAction.scaleX(to: 0, duration: flippingDuration)
            let changeTexture = SKAction.run {
                self.texture = SKTexture(imageNamed: "kabooButtonDown")
            }
            let turnBackEffect = SKAction.scaleX(to: 1, duration: flippingDuration)
            let sequence = SKAction.sequence([halfTurnEffect,changeTexture,turnBackEffect])
            
            run(sequence)
            runEffects()
        }
    }
    
    func runEffects() {
        if savedSfx {
            SoundManager.sharedManager.playSound(sound: "coin", type: "mp3")
        }
        
        if savedVibration {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
