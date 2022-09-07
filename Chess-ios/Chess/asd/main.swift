//
//  main.swift
//  chess-program
//
//  Created by Cseri Ádám on 2022. 05. 02..
//

import Foundation

var allMoves: Array<Array<Spot>>? = nil
var fromSpot: Spot? = nil
var toSpot: Spot? = nil
var showPanel = false

// main
let p1 = Player(isWhite: true)
let p2 = Player(isWhite: false)
let game = Game(player1: p1, player2: p2)

game.printBoard()
game.showSelectedMoves()

while !game.isGameOver() {
    move(game: game)
    
    game.printBoard()
    game.showSelectedMoves()
    game.updateStatus()
}
announceGameEnd(game: game)

func move(game: Game) {
    let player = game.getCurrentPlayer()
    if showPanel { showPromoPanel() }
    
    let onClick = onClick()
    if !"qrbn".contains(onClick) || onClick.count != 1 {
        let selectedSpot = game.board.getSpotById(id: onClick)
        if player.isWhite == selectedSpot.piece.isWhite {
            selectSpot(game: game, spot: selectedSpot)
        } else {
            if (fromSpot != nil && game.isPromotion(fromSpot: fromSpot!)) {
                selectSpotToMovePromo(spot: selectedSpot)
            } else {
                selectSpotToMove(game: game, player: player, spot: selectedSpot)
            }
        }
    } else {
        selectSpotToMovePromo(promo: onClick, player: player, game: game)
    }
}

func selectSpotToMovePromo(spot: Spot? = nil, promo: String? = nil, player: Player? = nil, game: Game? = nil) {
    if spot != nil {
        if spot!.highlighted {
            toSpot = spot
            showPanel = true
        }
    }
    if promo != nil {
        showPanel = false
        let move = Move(player: player!, chessNotation: fromSpot!.id+toSpot!.id+promo!)
        game!.moves.append(move)
        game!.board.makeMove(move: move)
        
        fromSpot = nil
        toSpot = nil
        for spot in game!.board.board.flatMap({ $0 }) {
            spot.highlighted = false
        }
    }
}

func selectSpotToMove(game: Game, player: Player, spot: Spot) {
    if spot.highlighted {
        toSpot = spot
        let move = Move(player: player, chessNotation: fromSpot!.id+toSpot!.id)
        game.moves.append(move)
        game.board.makeMove(move: move)
    }
    fromSpot = nil
    for spot in game.board.board.flatMap({ $0 }) {
        spot.highlighted = false
    }
}

func selectSpot(game: Game, spot: Spot) {
    for spot in game.board.board.flatMap({ $0 }) {
        spot.highlighted = false
    }
    fromSpot = spot
    toSpot = nil
    
    allMoves = [[Spot]]()
    allMoves!.append(game.board.filterNotSafeMoves(from: spot.id, moveList: spot.piece.possibleMoves(board: game.board)))
    allMoves!.append(game.board.filterNotSafeMoves(from: spot.id, moveList: spot.piece.possibleCaptureMoves(board: game.board)))
    
    if let isEmpty = allMoves?.isEmpty {
        if !isEmpty {
            for spot in allMoves!.flatMap({ $0 }) {
                spot.highlighted = true
            }
        }
    }
}

func showPromoPanel() {
    print("""
q - queen
r - rook
b - bishop
n - knight
""")
}

func onClick() -> String {
    print("Click on a square/promo unit:", terminator: " ")
    if let str = readLine() { return str.lowercased() }
    return ""
}

func announceGameEnd(game: Game) {
    print()
    if (game.status == GameStatus.ACTIVE) {
        print("The game is aborted!")
    } else {
        if (game.status == GameStatus.DRAW) {
            print("The game is DRAW!")
        } else {
            let color  = (game.status == GameStatus.WHITE_WIN) ? "WHITE" : "BLACK"
            print("The winner is the \(color) player!")
        }
    }
}
