//
//  KabooButton.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 02/03/22.
//

import Foundation
import SpriteKit

class KabooButton: SKSpriteNode {

    init() {
        super.init(texture: SKTexture(imageNamed: "kabooButtonUp"), color: .clear, size: .init(width: 72, height: 72))
        name = "KabooButton"
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var flippingTimerCount = 0
    var flippingTimer: Timer?
    
    func touch() {
        guard flippingTimerCount == 0 else { return }
        let flippingDuration: CGFloat = 1
        self.run(SKAction.scaleX(to: 0, duration: flippingDuration / 2))
        flippingTimer = Timer.scheduledTimer(withTimeInterval: flippingDuration / 2, repeats: true) { _ in
            if self.flippingTimerCount == 1 {
                self.texture = SKTexture(imageNamed: "kabooButtonDown")
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
}
