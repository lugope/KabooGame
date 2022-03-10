//
//  Player.swift
//  KabooGame
//
//  Created by Lucas Pereira on 11/02/22.
//

import Foundation

enum PlayerId: Int, CaseIterable {
    case player1 = 0, player2, player3, player4
}

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

class Player {
    let id: PlayerId
    let isDeviceHolder: Bool
    let userName: String
    let label: PlayerLabel
    
    var cards: [Card] = []
    var points: Int = 0
    
    init(id: PlayerId, isDeviceHolder: Bool, name: String) {
        self.id = id
        self.isDeviceHolder = isDeviceHolder
        self.userName = name
        
        label = PlayerLabel(userName: userName, image: (id.rawValue == 0 ? "savedPicture" : ""))
    }
}
