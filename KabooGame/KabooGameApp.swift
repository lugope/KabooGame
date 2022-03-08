//
//  KabooGameApp.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SwiftUI

@main
struct KabooGameApp: App {
    
    @AppStorage("music") var savedMusic = true
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        print(savedMusic)
        if savedMusic {
            SoundManager.sharedManager.playBackground()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuScreen()
        }
    }
}
