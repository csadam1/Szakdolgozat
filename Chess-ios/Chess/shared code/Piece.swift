import Foundation

class Piece {
    let isWhite: Bool?
    let char: String
    
    init (isWhite: Bool? = nil, char: String) {
        self.isWhite = isWhite
        self.char = char
    }
    
    func possibleMoves(board: Board) -> Array<Spot> { return [Spot]() }
    func possibleCaptureMoves(board: Board) -> Array<Spot> { return [Spot]() }
}

class King : Piece {
    init(isWhite: Bool? = nil) {
        let char = (isWhite == true) ? "K" : "k"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        var possibleMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        let enemyControlledSpotList = board.allSpotsOfPlayer(isWhite: !self.isWhite!)
        
        if (rank+1 <= 7 && !collided(spot: board.board[rank+1][file])) {
            possibleMoves.append(board.board[rank+1][file])
        }
        if (rank-1 >= 0 && !collided(spot: board.board[rank-1][file])) {
            possibleMoves.append(board.board[rank-1][file])
            }
        if (file-1 >= 0 && !collided(spot: board.board[rank][file-1])) {
            possibleMoves.append(board.board[rank][file-1])
        }
        if (file+1 <= 7 && !collided(spot: board.board[rank][file+1])) {
            possibleMoves.append(board.board[rank][file+1])
        }
        if (rank+1 <= 7 && file-1 >= 0 && !collided(spot: board.board[rank+1][file-1])) {
            possibleMoves.append(board.board[rank+1][file-1])
        }
        if (rank-1 >= 0 && file+1 <= 7 && !collided(spot: board.board[rank-1][file+1])) {
            possibleMoves.append(board.board[rank-1][file+1])
        }
        if (rank-1 >= 0 && file-1 >= 0 && !collided(spot: board.board[rank-1][file-1])) {
            possibleMoves.append(board.board[rank-1][file-1])
        }
        if (rank+1 <= 7 && file+1 <= 7 && !collided(spot: board.board[rank+1][file+1])) {
            possibleMoves.append(board.board[rank+1][file+1])
        }
        
        if (self.isWhite! && board.castPerm.contains("Q")
            && !collided(spot: board.board[7][3]) && !collided(spot: board.board[7][2]) && !collided(spot: board.board[7][1])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[7][3])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[7][2])
            && !board.isKingUnderCheck(enemySpotList: enemyControlledSpotList)) {
            possibleMoves.append(board.board[7][2])
        }
        if (self.isWhite! && board.castPerm.contains("K")
            && !collided(spot: board.board[7][5]) && !collided(spot: board.board[7][6])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[7][5])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[7][6])
            && !board.isKingUnderCheck(enemySpotList: enemyControlledSpotList)) {
            possibleMoves.append(board.board[7][6])
        }
        if (!self.isWhite! && board.castPerm.contains("q")
            && !collided(spot: board.board[0][3]) && !collided(spot: board.board[0][2]) && !collided(spot: board.board[0][1])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[0][3])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[0][2])
            && !board.isKingUnderCheck(enemySpotList: enemyControlledSpotList)) {
            possibleMoves.append(board.board[0][2])
        }
        if (!self.isWhite! && board.castPerm.contains("k")
            && !collided(spot: board.board[0][5]) && !collided(spot: board.board[0][6])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[0][5])
            && !isKingSpotUnderAttack(board: board, enemySpotList: enemyControlledSpotList, spot: board.board[0][6])
            && !board.isKingUnderCheck(enemySpotList: enemyControlledSpotList)) {
            possibleMoves.append(board.board[0][6])
        }
        
        return possibleMoves
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        var possibleCaptureMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        if (rank+1 <= 7 && collided(spot: board.board[rank+1][file]) && self.isWhite != board.board[rank+1][file].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank+1][file])
        }
        if (rank-1 >= 0 && collided(spot: board.board[rank-1][file]) && self.isWhite != board.board[rank-1][file].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank-1][file])
        }
        if (file-1 >= 0 && collided(spot: board.board[rank][file-1]) && self.isWhite != board.board[rank][file-1].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank][file-1])
        }
        if (file+1 <= 7 && collided(spot: board.board[rank][file+1]) && self.isWhite != board.board[rank][file+1].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank][file+1])
        }
        if (rank+1 <= 7 && file-1 >= 0 && collided(spot: board.board[rank+1][file-1]) && self.isWhite != board.board[rank+1][file-1].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank+1][file-1])
        }
        if (rank-1 >= 0 && file+1 <= 7 && collided(spot: board.board[rank-1][file+1]) && self.isWhite != board.board[rank-1][file+1].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank-1][file+1])
        }
        if (rank-1 >= 0 && file-1 >= 0 && collided(spot: board.board[rank-1][file-1]) && self.isWhite != board.board[rank-1][file-1].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank-1][file-1])
        }
        if (rank+1 <= 7 && file+1 <= 7 && collided(spot: board.board[rank+1][file+1]) && self.isWhite != board.board[rank+1][file+1].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank+1][file+1])
        }
        
        return possibleCaptureMoves
    }
    
    private func isKingSpotUnderAttack(board: Board, enemySpotList: Array<Spot>, spot: Spot) -> Bool {
        let rank = (self.isWhite!) ? 7 : 0
        let file = 4
        
        let spotTemp = spot.piece
        let kingTemp = board.board[rank][file].piece
        
        spot.piece = board.board[rank][file].piece
        board.board[rank][file].piece = Empty()
        
        let isUnderAttack = board.isKingUnderCheck(enemySpotList: enemySpotList)
        
        spot.piece = spotTemp
        board.board[rank][file].piece = kingTemp
        
        return isUnderAttack
    }
    
    private func collided(spot: Spot) -> Bool {
        return type(of: spot.piece) !== type(of: Empty())
    }
}

class Queen : Piece {
    init(isWhite: Bool? = nil) {
        let char = (isWhite == true) ? "Q" : "q"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        var possibleMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        var iterator = file-1
        while (iterator >= 0 && !collided(spot: board.board[rank][iterator])) {
            possibleMoves.append(board.board[rank][iterator])
            iterator-=1
        }
        
        iterator = file+1
        while (iterator <= 7 && !collided(spot: board.board[rank][iterator])) {
            possibleMoves.append(board.board[rank][iterator])
            iterator+=1
        }
        
        iterator = rank-1
        while (iterator >= 0 && !collided(spot: board.board[iterator][file])) {
            possibleMoves.append(board.board[iterator][file])
            iterator-=1
        }
        
        iterator = rank+1
        while (iterator <= 7 && !collided(spot: board.board[iterator][file])) {
            possibleMoves.append(board.board[iterator][file])
            iterator+=1
        }

        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator-=1
            rankIterator-=1
        }
        
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator+=1
            rankIterator+=1
        }
        
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator-=1
            rankIterator+=1
        }
        
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator+=1
            rankIterator-=1
        }
        
        return possibleMoves
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        var possibleCaptureMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        var iterator = file-1
        while (iterator >= 0 && !collided(spot: board.board[rank][iterator])) {
            iterator-=1
        }
        if (iterator >= 0 && self.isWhite != board.board[rank][iterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank][iterator])
        }
        
        iterator = file+1
        while (iterator <= 7 && !collided(spot: board.board[rank][iterator])) {
            iterator+=1
        }
        if (iterator <= 7 && self.isWhite != board.board[rank][iterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank][iterator])
        }
        
        iterator = rank-1
        while (iterator >= 0 && !collided(spot: board.board[iterator][file])) {
            iterator-=1
        }
        if (iterator >= 0 && self.isWhite != board.board[iterator][file].piece.isWhite) {
            possibleCaptureMoves.append(board.board[iterator][file])
        }
        
        iterator = rank+1
        while (iterator <= 7 && !collided(spot: board.board[iterator][file])) {
            iterator+=1
        }
        if (iterator <= 7 && self.isWhite != board.board[iterator][file].piece.isWhite) {
            possibleCaptureMoves.append(board.board[iterator][file])
        }
        
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator-=1
            rankIterator-=1
        }
        if (fileIterator >= 0 && rankIterator >= 0 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator+=1
            rankIterator+=1
        }
        if (fileIterator <= 7 && rankIterator <= 7 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator-=1
            rankIterator+=1
        }
        if (fileIterator >= 0 && rankIterator <= 7 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator+=1
            rankIterator-=1
        }
        if (fileIterator <= 7 && rankIterator >= 0 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        return possibleCaptureMoves
    }
    
    private func collided(spot: Spot) -> Bool {
        return type(of: spot.piece) !== type(of: Empty())
    }
}

class Rook : Piece {
    init(isWhite: Bool? = nil) {
        let char = (isWhite == true) ? "R" : "r"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        var possibleMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        var iterator = file-1
        while (iterator >= 0 && !collided(spot: board.board[rank][iterator])) {
            possibleMoves.append(board.board[rank][iterator])
            iterator-=1
        }
        
        iterator = file+1
        while (iterator <= 7 && !collided(spot: board.board[rank][iterator])) {
            possibleMoves.append(board.board[rank][iterator])
            iterator+=1
        }
        
        iterator = rank-1
        while (iterator >= 0 && !collided(spot: board.board[iterator][file])) {
            possibleMoves.append(board.board[iterator][file])
            iterator-=1
        }
        
        iterator = rank+1
        while (iterator <= 7 && !collided(spot: board.board[iterator][file])) {
            possibleMoves.append(board.board[iterator][file])
            iterator+=1
        }
        
        return possibleMoves
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        var possibleCaptureMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        var iterator = file-1
        while (iterator >= 0 && !collided(spot: board.board[rank][iterator])) {
            iterator-=1
        }
        if (iterator >= 0 && self.isWhite != board.board[rank][iterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank][iterator])
        }
        
        iterator = file+1
        while (iterator <= 7 && !collided(spot: board.board[rank][iterator])) {
            iterator+=1
        }
        if (iterator <= 7 && self.isWhite != board.board[rank][iterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rank][iterator])
        }
        
        iterator = rank-1
        while (iterator >= 0 && !collided(spot: board.board[iterator][file])) {
            iterator-=1
        }
        if (iterator >= 0 && self.isWhite != board.board[iterator][file].piece.isWhite) {
            possibleCaptureMoves.append(board.board[iterator][file])
        }
        
        iterator = rank+1
        while (iterator <= 7 && !collided(spot: board.board[iterator][file])) {
            iterator+=1
        }
        if (iterator <= 7 && self.isWhite != board.board[iterator][file].piece.isWhite) {
            possibleCaptureMoves.append(board.board[iterator][file])
        }
        
        return possibleCaptureMoves
    }
    
    private func collided(spot: Spot) -> Bool {
        return type(of: spot.piece) !== type(of: Empty())
    }
}

class Knight : Piece {
    init(isWhite: Bool? = nil) {
        let char = (isWhite == true) ? "N" : "n"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        var possibleMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        if (rank+2 <= 7) {
            if (file-1 >= 0 && !collided(spot: board.board[rank+2][file-1])) {
                possibleMoves.append(board.board[rank+2][file-1])
            }
            if (file+1 <= 7 && !collided(spot: board.board[rank+2][file+1])) {
                possibleMoves.append(board.board[rank+2][file+1])
            }
        }
        
        if (rank-2 >= 0) {
            if (file-1 >= 0 && !collided(spot: board.board[rank-2][file-1])) {
                possibleMoves.append(board.board[rank-2][file-1])
            }
            if (file+1 <= 7 && !collided(spot: board.board[rank-2][file+1])) {
                possibleMoves.append(board.board[rank-2][file+1])
            }
        }
        
        if (file-2 >= 0) {
            if (rank-1 >= 0 && !collided(spot: board.board[rank-1][file-2])) {
                possibleMoves.append(board.board[rank-1][file-2])
            }
            if (rank+1 <= 7 && !collided(spot: board.board[rank+1][file-2])) {
                possibleMoves.append(board.board[rank+1][file-2])
            }
        }
        
        if (file+2 <= 7) {
            if (rank-1 >= 0 && !collided(spot: board.board[rank-1][file+2])) {
                possibleMoves.append(board.board[rank-1][file+2])
            }
            if (rank+1 <= 7 && !collided(spot: board.board[rank+1][file+2])) {
                possibleMoves.append(board.board[rank+1][file+2])
            }
        }
        
        return possibleMoves
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        var possibleCaptureMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        if (rank+2 <= 7) {
            if (file-1 >= 0 && collided(spot: board.board[rank+2][file-1]) && self.isWhite != board.board[rank+2][file-1].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank+2][file-1])
            }
            if (file+1 <= 7 && collided(spot: board.board[rank+2][file+1]) && self.isWhite != board.board[rank+2][file+1].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank+2][file+1])
            }
        }
        
        if (rank-2 >= 0) {
            if (file-1 >= 0 && collided(spot: board.board[rank-2][file-1]) && self.isWhite != board.board[rank-2][file-1].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank-2][file-1])
            }
            if (file+1 <= 7 && collided(spot: board.board[rank-2][file+1]) && self.isWhite != board.board[rank-2][file+1].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank-2][file+1])
            }
        }
        
        if (file-2 >= 0) {
            if (rank-1 >= 0 && collided(spot: board.board[rank-1][file-2]) && self.isWhite != board.board[rank-1][file-2].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank-1][file-2])
            }
            if (rank+1 <= 7 && collided(spot: board.board[rank+1][file-2]) && self.isWhite != board.board[rank+1][file-2].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank+1][file-2])
            }
        }
        
        if (file+2 <= 7) {
            if (rank-1 >= 0 && collided(spot: board.board[rank-1][file+2]) && self.isWhite != board.board[rank-1][file+2].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank-1][file+2])
            }
            if (rank+1 <= 7 && collided(spot: board.board[rank+1][file+2]) && self.isWhite != board.board[rank+1][file+2].piece.isWhite) {
                possibleCaptureMoves.append(board.board[rank+1][file+2])
            }
        }
        
        return possibleCaptureMoves
    }
    
    private func collided(spot: Spot) -> Bool {
        return type(of: spot.piece) !== type(of: Empty())
    }
}

class Bishop : Piece {
    init(isWhite: Bool? = nil) {
        let char = (isWhite == true) ? "B" : "b"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        var possibleMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator-=1
            rankIterator-=1
        }
        
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator+=1
            rankIterator+=1
        }
        
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator-=1
            rankIterator+=1
        }
        
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            possibleMoves.append(board.board[rankIterator][fileIterator])
            fileIterator+=1
            rankIterator-=1
        }
        
        return possibleMoves
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        var possibleCaptureMoves = [Spot]()
        let (rank, file) = board.getPosition(piece: self)
        
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator-=1
            rankIterator-=1
        }
        if (fileIterator >= 0 && rankIterator >= 0 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator+=1
            rankIterator+=1
        }
        if (fileIterator <= 7 && rankIterator <= 7 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator-=1
            rankIterator+=1
        }
        if (fileIterator >= 0 && rankIterator <= 7 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(spot: board.board[rankIterator][fileIterator])) {
            fileIterator+=1
            rankIterator-=1
        }
        if (fileIterator <= 7 && rankIterator >= 0 && self.isWhite != board.board[rankIterator][fileIterator].piece.isWhite) {
            possibleCaptureMoves.append(board.board[rankIterator][fileIterator])
        }
        
        return possibleCaptureMoves
    }
    
    private func collided(spot: Spot) -> Bool {
        return type(of: spot.piece) !== type(of: Empty())
    }
}

class Pawn : Piece {
    init(isWhite: Bool? = nil) {
        let char = (isWhite == true) ? "P" : "p"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        let (rank, file) = board.getPosition(piece: self)
        let direction = (self.isWhite!) ? -1 : 1
        
        let spot1 = board.board[rank+direction][file]
        if !isEmptySpot(spot: spot1) {
            return [Spot]()
        }
        if !hasMoved(rank: rank) {
            let spot2 = board.board[rank+direction*2][file]
            if isEmptySpot(spot: spot2) {
                return [spot1, spot2]
            }
        }
        return [spot1]
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        let (rank, file) = board.getPosition(piece: self)
        let direction = (self.isWhite!) ? -1 : 1
        
        var captureList = [Spot]()
        if (0...6).contains(file) {
            let rightDiagonalSpot = board.board[rank+direction][file+1]
            if (!isEmptySpot(spot: rightDiagonalSpot) && differentColors(piece: rightDiagonalSpot.piece)) {
                captureList.append(rightDiagonalSpot)
            }
            if (board.enPas != "-" && rightDiagonalSpot === board.getSpotById(id: board.enPas)) {
                captureList.append(rightDiagonalSpot)
            }
        }
        if (1...7).contains(file) {
            let leftDiagonalSpot = board.board[rank+direction][file-1]
            if (!isEmptySpot(spot: leftDiagonalSpot) && differentColors(piece: leftDiagonalSpot.piece)) {
                captureList.append(leftDiagonalSpot)
            }
            if (board.enPas != "-" && leftDiagonalSpot === board.getSpotById(id: board.enPas)) {
                captureList.append(leftDiagonalSpot)
            }
        }
        return captureList
    }
    
    private func differentColors(piece: Piece) -> Bool {
        return self.isWhite! != piece.isWhite
    }
    
    private func isEmptySpot(spot: Spot) -> Bool {
        return type(of: spot.piece) === type(of: Empty())
    }
    
    private func hasMoved(rank: Int) -> Bool {
        if self.isWhite! && rank == 6 {
            return false
        }
        if !self.isWhite! && rank == 1 {
            return false
        }
        return true
    }
}

class Empty : Piece {
    init(isWhite: Bool? = nil) {
        let char = "-"
        super.init(isWhite: isWhite, char: char)
    }
    
    override func possibleMoves(board: Board) -> Array<Spot> {
        return [Spot]()
    }
    override func possibleCaptureMoves(board: Board) -> Array<Spot> {
        return [Spot]()
    }
}
