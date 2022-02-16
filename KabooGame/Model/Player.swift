//
//  Player.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation


class Player {
    let id: Int
    var hand: [Card] = []
    
    init(id: Int) {
        self.id = id
    }
}
