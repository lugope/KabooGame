//
//  ExitButton.swift
//  KabooGame
//
//  Created by Lucas Pereira on 07/03/22.
//

import Foundation
import SpriteKit

class ExitButton: SKSpriteNode {
    init() {
        let boxSize = CARD_SIZE_HEIGHT/2
        super.init(texture: SKTexture(imageNamed: "exitButton"), color: UIColor.clear, size: CGSize(width: boxSize, height: boxSize))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
