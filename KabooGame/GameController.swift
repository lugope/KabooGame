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
    
    init() {
        self.players = []
        self.gameScene = nil
    }
}
