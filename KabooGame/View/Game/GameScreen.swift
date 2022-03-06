//
//  GameScreen.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SwiftUI
import SpriteKit

struct GameScreen: View {
    
    @Binding var popToRoot: Bool
    
    var body: some View {
        GameView(popToRoot: $popToRoot)
            .navigationBarHidden(true)
    }
}
