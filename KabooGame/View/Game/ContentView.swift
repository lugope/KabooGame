//
//  ContentView.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        GameView()
            .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
