//
//  Board.swift
//  chess-program
//
//  Created by Cseri Ádám on 2022. 05. 02..
//

import Foundation

class Board {
    let board: Array<Array<Spot>>
    
    lazy var side: String = ""
    lazy var enPas: String = ""
    lazy var castPerm: String = ""
    lazy var halfMove: Int = 0
    lazy var fullMove: Int = 0
    
    init() {
        board = (1...8).map { _ in (1...8).map { _ in Spot() } }
        parseFEN()
    }
    
    func toPrint() {
        for row in board {
            let rank = row[0].id[1..<2]
            let spotsInARow = row.map{ it in it.piece.char }.joined(separator: "  ")
            
            print(rank, spotsInARow, separator: "   ")
        }
        let files = board[0].map{ it in it.id[0..<1] }.joined(separator: "  ")
        print("\n   ", files, "\n")
        
        print("""
Side: \(side)
En Passant: \(enPas)
Castling Permission: \(castPerm)
""")
    }
    
    func toPrintIDs() {
        for row in board {
            for spot in row {
                print(spot.id, terminator: " ")
            }
            print()
        }
    }
    
    func parseFEN(customStringFEN: String = START_FEN) {
        let customFEN = customStringFEN.components(separatedBy: " ")
        var rowIterator = 0
        var colIterator = 0
        
        for char in customFEN[0] {
            switch char {
            case "P":
                board[rowIterator][colIterator].piece = Pawn(isWhite: true)
            case "p":
                board[rowIterator][colIterator].piece = Pawn(isWhite: false)
            case "R":
                board[rowIterator][colIterator].piece = Rook(isWhite: true)
            case "r":
                board[rowIterator][colIterator].piece = Rook(isWhite: false)
            case "N":
                board[rowIterator][colIterator].piece = Knight(isWhite: true)
            case "n":
                board[rowIterator][colIterator].piece = Knight(isWhite: false)
            case "B":
                board[rowIterator][colIterator].piece = Bishop(isWhite: true)
            case "b":
                board[rowIterator][colIterator].piece = Bishop(isWhite: false)
            case "K":
                board[rowIterator][colIterator].piece = King(isWhite: true)
            case "k":
                board[rowIterator][colIterator].piece = King(isWhite: false)
            case "Q":
                board[rowIterator][colIterator].piece = Queen(isWhite: true)
            case "q":
                board[rowIterator][colIterator].piece = Queen(isWhite: false)
            case "/":
                rowIterator+=1
                colIterator = -1
            default:
                colIterator += Int(String(char))!-1
            }
            colIterator+=1
        }
        
        self.side = customFEN[1]
        self.castPerm = customFEN[2]
        self.enPas = customFEN[3]
        self.halfMove = Int(customFEN[4])!
        self.fullMove = Int(customFEN[5])!
    }
    
    func makeMove(move: Move) {
        var capture = type(of: getSpotById(id: move.to).piece) != type(of: Empty())
        
        let movingPiece = getSpotById(id: move.from).piece
        getSpotById(id: move.from).piece = Empty()
        getSpotById(id: move.to).piece = movingPiece
        
        if isEnPasMove(toSquare: move.to, piece: movingPiece) {
            capture = true
            captureEnPas(move: move)
        }
        
        if isPromotionMove(move: move) {
            promotePawn(spot: getSpotById(id: move.to), promotion: move.promotion!)
        }
        
        if isCastlingMove(move: move) {
            replaceRook(move: move)
        }
        
        side = (side == "w") ? "b" : "w"
        enPas = updateEnPas(piece: movingPiece, move: move)
        castPerm = updateCastPerm(castPerm: castPerm)
        halfMove = updateHalfMove(piece: movingPiece, capture: capture)
        fullMove = updateFullMove()
    }
    
    func replaceRook(move: Move) {
        if (move.player.isWhite && move.from == "e1" && move.to == "c1" && castPerm.contains("Q")) {
            let rookTemp = board[7][0].piece
            board[7][0].piece = Empty()
            board[7][3].piece = rookTemp
        }
        if (move.player.isWhite && move.from == "e1" && move.to == "g1" && castPerm.contains("K")) {
            let rookTemp = board[7][7].piece
            board[7][7].piece = Empty()
            board[7][5].piece = rookTemp
        }
        if (!move.player.isWhite && move.from == "e8" && move.to == "c8" && castPerm.contains("q")) {
            let rookTemp = board[0][0].piece
            board[0][0].piece = Empty()
            board[0][3].piece = rookTemp
        }
        if (!move.player.isWhite && move.from == "e8" && move.to == "g8" && castPerm.contains("k")) {
            let rookTemp = board[0][7].piece
            board[0][7].piece = Empty()
            board[0][5].piece = rookTemp
        }
    }
    
    func isCastlingMove(move: Move) -> Bool {
        if castPerm.contains("-") {
            return false
        }
        if (move.player.isWhite && move.from == "e1" && move.to == "c1" && castPerm.contains("Q")) {
            return true
        }
        if (move.player.isWhite && move.from == "e1" && move.to == "g1" && castPerm.contains("K")) {
            return true
        }
        if (!move.player.isWhite && move.from == "e8" && move.to == "c8" && castPerm.contains("q")) {
            return true
        }
        if (!move.player.isWhite && move.from == "e8" && move.to == "g8" && castPerm.contains("k")) {
            return true
        }
        return false
    }
    
    func isPromotionMove(move: Move) -> Bool {
        return move.promotion != nil
    }
    
    func isEnPasMove(toSquare: String, piece: Piece) -> Bool {
        return toSquare == enPas && type(of: piece) == type(of: Pawn())
    }
    
    func promotePawn(spot: Spot, promotion: String) {
        if (promotion == "q") {
            spot.piece = (side == "w") ? Queen(isWhite: true) : Queen(isWhite: false)
        }
        if (promotion == "r") {
            spot.piece = (side == "w") ? Rook(isWhite: true) : Rook(isWhite: false)
        }
        if (promotion == "n") {
            spot.piece = (side == "w") ? Knight(isWhite: true) : Knight(isWhite: false)
        }
        if (promotion == "b") {
            spot.piece = (side == "w") ? Bishop(isWhite: true) : Bishop(isWhite: false)
        }
    }
    
    func captureEnPas(move: Move) {
        let direction = (move.player.isWhite) ? 1 : -1
        let (rank, file) = getPosition(piece: getSpotById(id: move.to).piece)
        board[rank+direction][file].piece = Empty()
    }
    
    func getSpotById(id: String) -> Spot {
        return board.flatMap { $0 }.first { $0.id == id }!
    }
    
    func getPosition(piece: Piece) -> (Int, Int) {
        let row = board.first { row in row.contains { $0.piece === piece } }!
        let rankIndex = board.findIndexNS(customArray: row)
        let fileIndex = board[rankIndex].firstIndex { $0.piece === piece }!
        return (rankIndex, fileIndex)
    }
    
    func filterNotSafeMoves(from: String, moveList: Array<Spot>) -> Array<Spot> {
        return moveList.filter { toSpot in
            let to = toSpot.id
            let saveFromPiece = getSpotById(id: from).piece
            let savetoPiece = getSpotById(id: to).piece
            
            getSpotById(id: to).piece = getSpotById(id: from).piece
            getSpotById(id: from).piece = Empty()
            
            let enemySpotList = allSpotsOfPlayer(isWhite: !getSpotById(id: to).piece.isWhite!)
            let kingUnderAttack = isKingUnderCheck(enemySpotList: enemySpotList)
            
            getSpotById(id: from).piece = saveFromPiece
            getSpotById(id: to).piece = savetoPiece
            
            return !kingUnderAttack
        }
    }
    
    func isKingUnderCheck(enemySpotList: Array<Spot>) -> Bool {
        let array = enemySpotList.map { $0.piece.possibleCaptureMoves(board: self).map { inner$0 in type(of: inner$0.piece) } }.flatMap { $0 }
        return Piece.contains(array: array, elem: King())
    }
    
    func allSpotsOfPlayer(isWhite: Bool) -> Array<Spot> {
        return board.flatMap { rank in rank.filter { type(of: $0.piece) != type(of: Empty()) && isWhite == $0.piece.isWhite } }
    }
    
    func updateEnPas(piece: Piece, move: Move) -> String {
        if (type(of: piece) != type(of: Pawn())) {
            return "-"
        }
        if (piece.isWhite! && board[6].map { $0.id }.contains(move.from) && board[4].map { $0.id }.contains(move.to)) {
            return String(move.from.first!) + String(Int(String(move.from.last!))!+1)
        }
        if (!piece.isWhite! && board[1].map { $0.id }.contains(move.from) && board[3].map { $0.id }.contains(move.to)) {
            return String(move.from.first!) + String(Int(String(move.from.last!))!-1)
        }
        return "-"
    }
    
    func updateCastPerm(castPerm: String) -> String {
        if (castPerm == "-") {
            return castPerm
        }
        
        var castPerm2 = (type(of: board[7][0].piece) != type(of: Rook())) ? castPerm.filter { $0 != "Q" } : castPerm
        castPerm2 = (type(of: board[7][7].piece) != type(of: Rook())) ? castPerm2.filter { $0 != "K" } : castPerm2
        castPerm2 = (type(of: board[7][4].piece) != type(of: King())) ? castPerm2.filter { $0 != "K" && $0 != "Q" } : castPerm2
        castPerm2 = (type(of: board[0][0].piece) != type(of: Rook())) ? castPerm.filter { $0 != "q" } : castPerm2
        castPerm2 = (type(of: board[0][7].piece) != type(of: Rook())) ? castPerm2.filter { $0 != "k" } : castPerm2
        castPerm2 = (type(of: board[0][4].piece) != type(of: King())) ? castPerm2.filter { $0 != "k" && $0 != "q" } : castPerm2
        
        if castPerm2.isEmpty {
            castPerm2 = "-"
        }
        return castPerm2
    }
    
    func updateHalfMove(piece: Piece, capture: Bool) -> Int {
        if (type(of: piece) == type(of: Pawn()) || capture) {
            return 0
        }
        return self.halfMove+1
    }
    
    func updateFullMove() -> Int {
        return (side == "w") ? self.fullMove+1 : self.fullMove
    }
}
