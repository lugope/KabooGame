//
//  TipLabel.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 09/03/22.
//

import SpriteKit

class TipLabel: SKSpriteNode {
    
    let labelNode = SKLabelNode()
    
    init() {
        super.init(texture: .none, color: .clear, size: CGSize(width: CARD_SIZE_WIDTH * 2, height: CARD_SIZE_WIDTH * 1.3))
        isUserInteractionEnabled = false
        
        labelNode.numberOfLines = 0
        labelNode.lineBreakMode = .byWordWrapping
        labelNode.fontColor = .black
        labelNode.fontSize = 12
        labelNode.fontName = ".SFUI-Regular"
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
