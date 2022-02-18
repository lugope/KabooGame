//
//  GameView.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
        //        SpriteView(scene: scene)
        //            .frame(width: screenWidth, height: screenHeight)
        //            .ignoresSafeArea()
        ZStack {
            Color.black
                .ignoresSafeArea()
            Image("temp_gameScene")
                .resizable()
                .offset(x: 0, y: -6)
                .blur(radius: 3)
            Button {
                self.mode.wrappedValue.dismiss()
            } label: {
                
                RoundedRectangle(cornerRadius: 20)
                    .padding()
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(width: 330, height: 170, alignment: .center)
                    .overlay(
                        VStack(spacing: 20) {
                            Text("The game view will be implemented in the next update!")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Tap here to go back")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                            .padding()
                            .padding()
                    )
            }
            .offset(x: 0, y: -150)
        }
        .navigationBarHidden(true)
    }
}
