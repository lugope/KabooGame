//
//  GameScene.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        var card = Card(cardId: 2)
        card.position = CGPoint(x: 200, y: 500)
        addChild(card)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Run when touch is detected
    }
}

