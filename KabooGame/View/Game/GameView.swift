//
//  GameView.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: screenWidth, height: screenHeight)
            .ignoresSafeArea()
    }
}
