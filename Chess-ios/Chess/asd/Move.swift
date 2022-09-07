//
//  Move.swift
//  chess-program
//
//  Created by Cseri Ádám on 2022. 05. 02..
//

import Foundation

class Move {
    let from: String
    let to: String
    let promotion: String?
    let player: Player
    
    init(player: Player, chessNotation: String) {
        self.from = chessNotation[0..<2]
        self.to = chessNotation[2..<4]
        promotion = (chessNotation.count == 5) ? chessNotation[4..<5] : nil
        self.player = player
    }
}
