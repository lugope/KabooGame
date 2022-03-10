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
    func exitGame()
}

struct GameView: View, GameViewDelegate {
    
    @State var showResults: Bool? = false
    @State var goBack: Bool? = false
    @State var players: [Player] = []
    @Binding var popToRoot: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func finishGame(players: [Player]) {
        self.players = players
        showResults = true
    }
    
    func exitGame() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var scene: SKScene {
        let scene = GameScene()
        scene.gameViewDelegate = self
        scene.size = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
            ZStack {
            NavigationLink(destination: ResultsScreen(players: players, popToRoot: $popToRoot), tag: true, selection: $showResults) { EmptyView() }
            .isDetailLink(false)
            
            SpriteView(scene: scene)
                .frame(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                .ignoresSafeArea()
                .navigationBarHidden(true)
        }
    }
}
