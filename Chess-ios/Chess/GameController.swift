import Foundation
import SwiftUI

func proposal(player: Player, game: Game, input: String) {
    if (input == "r" && player.isWhite) {
        game.status = GameStatus.BLACK_WIN
    }
    if (input == "r" && !player.isWhite) {
        game.status = GameStatus.WHITE_WIN
    }
    
    if (input == "y") {
        game.status = GameStatus.DRAW
    }
}

func promotion(promo: String, player: Player, game: Game, showPanel: inout Bool, fromSpot: inout Spot?, toSpot: inout Spot?) {
    showPanel = false
    let move = Move(player: player, chessNotation: fromSpot!.id+toSpot!.id+promo)
    game.moves.append(move)
    game.board.makeMove(move: move)
    
    fromSpot = nil
    toSpot = nil
    for spot in game.board.board.flatMap({ $0 }) {
        spot.highlighted = false
    }
}

func announceGameEnd(game: Game, gameOver: inout Bool, gameOverText: inout String) {
    gameOver = true
    if game.status == GameStatus.DRAW {
        gameOverText = "The game is DRAW!"
    } else {
        gameOverText = "The winner is the " + ((game.status==GameStatus.WHITE_WIN) ? "WHITE" : "BLACK") + " player!"
    }
}

func isGameOver(game: Game) -> Bool {
    return game.status != GameStatus.ACTIVE
}

func updateGameState(state: inout Bool) {
    state = !state
}

func getCurrentColor(game: Game) -> String {
    return "Current player: " + ((game.getCurrentPlayer().isWhite) ? "white" : "black")
}

func selectSpot(game: Game, spot: Spot?, toSpot: inout Spot?, allMoves: inout Array<Array<Spot>>?) {
    for spot in game.board.board.flatMap({ $0 }) {
        spot.highlighted = false
    }
    toSpot = nil
    
    allMoves = [[Spot]]()
    allMoves!.append(game.board.filterNotSafeMoves(from: spot!.id, moveList: spot!.piece.possibleMoves(board: game.board)))
    allMoves!.append(game.board.filterNotSafeMoves(from: spot!.id, moveList: spot!.piece.possibleCaptureMoves(board: game.board)))
    
    if let isEmpty = allMoves?.isEmpty {
        if !isEmpty {
            for spot in allMoves!.flatMap({ $0 }) {
                spot.highlighted = true
            }
        }
    }
}

func selectSpotToMovePromo(spot: Spot, toSpot: inout Spot?, showPanel: inout Bool) {
    if (spot.highlighted) {
        toSpot = spot
        showPanel = true
    }
}

func selectSpotToMove(game: Game, player: Player, spot: Spot, fromSpot: inout Spot?, toSpot: inout Spot?) {
    if spot.highlighted {
        toSpot = spot
        let move = Move(player: player, chessNotation: fromSpot!.id + toSpot!.id)
        game.moves.append(move)
        game.board.makeMove(move: move)
    }
    fromSpot = nil
    for spot in game.board.board.flatMap({ $0 }) {
        spot.highlighted = false
    }
}

func setLayout(game: Game, pos: Int) -> Image {
    let imageName = selectImage(char: game.board.board[pos/8][pos%8].piece.char)
    return Image(imageName)
}

func selectImage(char: String) -> String {
    switch char {
    case "P":
        return "chess_plt60"
    case "p":
        return "chess_pdt60"
    case "B":
        return "chess_blt60"
    case "b":
        return "chess_bdt60"
    case "N":
        return "chess_nlt60"
    case "n":
        return "chess_ndt60"
    case "R":
        return "chess_rlt60"
    case "r":
        return "chess_rdt60"
    case "Q":
        return "chess_qlt60"
    case "q":
        return "chess_qdt60"
    case "K":
        return "chess_klt60"
    case "k":
        return "chess_kdt60"
    default:
        return "chess_unoccupied"
    }
}
