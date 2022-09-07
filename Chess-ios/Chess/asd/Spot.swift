//
//  Spot.swift
//  chess-program
//
//  Created by Cseri Ádám on 2022. 05. 03..
//

import Foundation

class Spot {
    let id: String
    var highlighted: Bool
    var piece: Piece
    
    init(piece: Piece = Empty() as Piece) {
        self.piece = piece
        self.highlighted = false
        self.id = String(Spot.setId)
        Spot.updateIdSetter()
    }
    
    static var setId = Array("a8")
    static func updateIdSetter() {
        if setId[0].inc() > "h" {
            setId[0] = "a"
            if setId[1].dec() < "1" {
                setId[1] = "8"
            }
        }
    }
}
