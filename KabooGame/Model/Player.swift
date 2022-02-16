//
//  Player.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

enum PlayerId {
    case player1, player2, player3, player4
}

import Foundation


class Player {
    let id: PlayerId
    let isDeviceHolder: Bool
    
    var cards: [Card] = []
    var points: Int = 0
    
    init(id: PlayerId, isDeviceHolder: Bool) {
        self.id = id
        self.isDeviceHolder = isDeviceHolder
    }
}
