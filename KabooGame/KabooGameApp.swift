//
//  KabooGameApp.swift
//  KabooGame
//
//  Created by Lucas Pereira on 10/02/22.
//

import SwiftUI

@main
struct KabooGameApp: App {    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuScreen()
        }
    }
}
