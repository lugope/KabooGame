//
//  GameView.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI

protocol GameViewDelegate {
    func finishGame(players: [Player])
}

struct GameView: View, GameViewDelegate {
    
    @State var showResults: Bool? = false
    @State var players: [Player] = []
    @Binding var popToRoot: Bool
    
    func finishGame(players: [Player]) {
        self.players = players
        showResults = true
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var scene: SKScene {
        let scene = GameScene()
        scene.gameViewDelegate = self
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        //NavigationView {
            ZStack {
            NavigationLink(destination: ResultsScreen(players: players, popToRoot: $popToRoot), tag: true, selection: $showResults) { EmptyView() }
            .isDetailLink(false)
            
            SpriteView(scene: scene)
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()
                .navigationBarHidden(true)
            //}
        }
    }
}
