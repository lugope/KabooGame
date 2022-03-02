//
//  KabooButton.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 02/03/22.
//

import Foundation
import SpriteKit

class KabooButton: SKSpriteNode {
    
    private let nameLabel = SKLabelNode()

    init() {
        super.init(texture: SKTexture(), color: .green, size: .init(width: 50, height: 25))
        zPosition = CardLevel.board.rawValue
        name = "KabooButton"
        nameLabel.text = "Kaboo"
        nameLabel.fontColor = .black
        nameLabel.position = CGPoint(
            x: frame.midX,
            y: frame.midY
        )
        addChild(nameLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
