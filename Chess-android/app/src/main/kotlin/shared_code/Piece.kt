package shared_code

/**
 * Rules for possible moves: https://www.flyordie.com/games/help/chess/en/pieces_chess.html
 */

abstract class Piece(_isWhite: Boolean? = null) {
    /**
     * Collects all the possible moves and returns it in a list of spots
     */
    abstract fun possibleMoves(board: Board): List<Spot>
    /**
     * Collects all the possible captures and returns it in a list of spots
     */
    abstract fun possibleCaptureMoves(board: Board): List<Spot>

    val isWhite: Boolean?
    abstract val char: Char

    init {
        isWhite = _isWhite
    }
}


class King(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = if (isWhite!!) 'K' else 'k'

    override fun possibleMoves(board: Board): List<Spot> {
        val possibleMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates
        val enemyControlledSpotList = board.allSpotsOfPlayer(!this.isWhite!!)

        // Going up
        if (rank+1 <= 7 && !collided(board.board[rank+1][file])) possibleMoves.add(board.board[rank+1][file])
        // Going down
        if (rank-1 >= 0 && !collided(board.board[rank-1][file])) possibleMoves.add(board.board[rank-1][file])
        // Going left
        if (file-1 >= 0 && !collided(board.board[rank][file-1])) possibleMoves.add(board.board[rank][file-1])
        // Going right
        if (file+1 <= 7 && !collided(board.board[rank][file+1])) possibleMoves.add(board.board[rank][file+1])
        // Going left primary diagonal
        if (rank+1 <= 7 && file-1 >= 0 && !collided(board.board[rank+1][file-1])) possibleMoves.add(board.board[rank+1][file-1])
        // Going right primary diagonal
        if (rank-1 >= 0 && file+1 <= 7 && !collided(board.board[rank-1][file+1])) possibleMoves.add(board.board[rank-1][file+1])
        // Going left secondary diagonal
        if (rank-1 >= 0 && file-1 >= 0 && !collided(board.board[rank-1][file-1])) possibleMoves.add(board.board[rank-1][file-1])
        // Going right secondary diagonal
        if (rank+1 <= 7 && file+1 <= 7 && !collided(board.board[rank+1][file+1])) possibleMoves.add(board.board[rank+1][file+1])

        // White shared_code.Queen-side castling
        if (this.isWhite && 'Q' in board.castPerm && !collided(board.board[7][3]) && !collided(board.board[7][2]) && !collided(board.board[7][1])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[7][3])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[7][2])
            && !board.isKingUnderCheck(enemyControlledSpotList))
            possibleMoves.add(board.board[7][2])
        // White shared_code.King-side castling
        if (this.isWhite && 'K' in board.castPerm && !collided(board.board[7][5]) && !collided(board.board[7][6])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[7][5])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[7][6])
            && !board.isKingUnderCheck(enemyControlledSpotList))
            possibleMoves.add(board.board[7][6])
        // Black shared_code.Queen-side castling
        if (!this.isWhite && 'q' in board.castPerm && !collided(board.board[0][3]) && !collided(board.board[0][2]) && !collided(board.board[0][1])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[0][3])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[0][2])
            && !board.isKingUnderCheck(enemyControlledSpotList))
            possibleMoves.add(board.board[0][2])
        // Black shared_code.King-side castling
        if (!this.isWhite && 'k' in board.castPerm && !collided(board.board[0][5]) && !collided(board.board[0][6])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[0][5])
            && !isKingSpotUnderAttack(board, enemyControlledSpotList, board.board[0][6])
            && !board.isKingUnderCheck(enemyControlledSpotList))
            possibleMoves.add(board.board[0][6])

        return possibleMoves
    }

    override fun possibleCaptureMoves(board: Board): List<Spot> {
        val possibleCaptureMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going up
        if (rank+1 <= 7 && collided(board.board[rank+1][file]) && this.isWhite!! != board.board[rank+1][file].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank+1][file])
        // Going down
        if (rank-1 >= 0 && collided(board.board[rank-1][file]) && this.isWhite!! != board.board[rank-1][file].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank-1][file])
        // Going left
        if (file-1 >= 0 && collided(board.board[rank][file-1]) && this.isWhite!! != board.board[rank][file-1].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank][file-1])
        // Going right
        if (file+1 <= 7 && collided(board.board[rank][file+1]) && this.isWhite!! != board.board[rank][file+1].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank][file+1])
        // Going left primary diagonal
        if (rank+1 <= 7 && file-1 >= 0 && collided(board.board[rank+1][file-1]) && this.isWhite!! != board.board[rank+1][file-1].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank+1][file-1])
        // Going right primary diagonal
        if (rank-1 >= 0 && file+1 <= 7 && collided(board.board[rank-1][file+1]) && this.isWhite!! != board.board[rank-1][file+1].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank-1][file+1])
        // Going left secondary diagonal
        if (rank-1 >= 0 && file-1 >= 0 && collided(board.board[rank-1][file-1]) && this.isWhite!! != board.board[rank-1][file-1].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank-1][file-1])
        // Going right secondary diagonal
        if (rank+1 <= 7 && file+1 <= 7 && collided(board.board[rank+1][file+1]) && this.isWhite!! != board.board[rank+1][file+1].piece.isWhite)
            possibleCaptureMoves.add(board.board[rank+1][file+1])

        return possibleCaptureMoves
    }

    /**
     * Checks if the selected spot is under attack by the other side.
     *   - saving the piece on the spot
     *   - moving the king to the selected spot
     *   - checking if the king is in check now
     *   - resetting the table
     */
    private fun isKingSpotUnderAttack(board: Board, enemySpotList: List<Spot>, spot: Spot): Boolean {
        val rank = if (this.isWhite!!) 7 else 0
        val file = 4
        // saving the piece on the spot
        val spotTemp = spot.piece
        val kingTemp = board.board[rank][file].piece

        // moving the king to the selected spot
        spot.piece = board.board[rank][file].piece
        board.board[rank][file].piece = Empty()

        // checking if the king is in check now
        val isUnderAttack = board.isKingUnderCheck(enemySpotList)

        // resetting the table
        spot.piece = spotTemp
        board.board[rank][file].piece = kingTemp

        return isUnderAttack
    }

    /**
     * Checks if the given piece is empty
     */
    private fun collided(spot: Spot): Boolean {
        return spot.piece::class != Empty::class
    }
}


class Queen(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = if (isWhite!!) 'Q' else 'q'

    override fun possibleMoves(board: Board): List<Spot> {
        val possibleMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going left side
        var iterator = file-1
        while (iterator >= 0 && !collided(board.board[rank][iterator])) {
            possibleMoves.add(board.board[rank][iterator])
            iterator--
        }
        // Going right side
        iterator = file+1
        while (iterator <= 7 && !collided(board.board[rank][iterator])) {
            possibleMoves.add(board.board[rank][iterator])
            iterator++
        }
        // Going up
        iterator = rank-1
        while (iterator >= 0 && !collided(board.board[iterator][file])) {
            possibleMoves.add(board.board[iterator][file])
            iterator--
        }
        // Going down
        iterator = rank+1
        while (iterator <= 7 && !collided(board.board[iterator][file])) {
            possibleMoves.add(board.board[iterator][file])
            iterator++
        }

        // Going left primary diagonal
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator--
            rankIterator--
        }
        // Going right primary diagonal
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator++
            rankIterator++
        }
        // Going left secondary diagonal
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator--
            rankIterator++
        }
        // Going right secondary diagonal
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator++
            rankIterator--
        }

        return possibleMoves
    }

    override fun possibleCaptureMoves(board: Board): List<Spot> {
        val possibleCaptureMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going left side
        var iterator = file-1
        while (iterator >= 0 && !collided(board.board[rank][iterator])) iterator--
        if (iterator >= 0 && this.isWhite != board.board[rank][iterator].piece.isWhite) possibleCaptureMoves.add(board.board[rank][iterator])
        // Going right side
        iterator = file+1
        while (iterator <= 7 && !collided(board.board[rank][iterator])) iterator++
        if (iterator <= 7 && this.isWhite != board.board[rank][iterator].piece.isWhite) possibleCaptureMoves.add(board.board[rank][iterator])
        // Going up
        iterator = rank-1
        while (iterator >= 0 && !collided(board.board[iterator][file])) iterator--
        if (iterator >= 0 && this.isWhite != board.board[iterator][file].piece.isWhite) possibleCaptureMoves.add(board.board[iterator][file])
        // Going down
        iterator = rank+1
        while (iterator <= 7 && !collided(board.board[iterator][file])) iterator++
        if (iterator <= 7 && this.isWhite != board.board[iterator][file].piece.isWhite) possibleCaptureMoves.add(board.board[iterator][file])

        // Going left primary diagonal
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator--
            rankIterator--
        }
        if (fileIterator >= 0 && rankIterator >= 0 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])
        // Going right primary diagonal
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator++
            rankIterator++
        }
        if (fileIterator <= 7 && rankIterator <= 7 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])
        // Going left secondary diagonal
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator--
            rankIterator++
        }
        if (fileIterator >= 0 && rankIterator <= 7 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])
        // Going right secondary diagonal
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator++
            rankIterator--
        }
        if (fileIterator <= 7 && rankIterator >= 0 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])

        return possibleCaptureMoves
    }

    /**
     * Checks if the given piece is empty
     */
    private fun collided(spot: Spot): Boolean {
        return spot.piece::class != Empty::class
    }
}


class Rook(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = if (isWhite!!) 'R' else 'r'

    override fun possibleMoves(board: Board): List<Spot> {
        val possibleMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going left side
        var iterator = file-1
        while (iterator >= 0 && !collided(board.board[rank][iterator])) {
            possibleMoves.add(board.board[rank][iterator])
            iterator--
        }
        // Going right side
        iterator = file+1
        while (iterator <= 7 && !collided(board.board[rank][iterator])) {
            possibleMoves.add(board.board[rank][iterator])
            iterator++
        }
        // Going up
        iterator = rank-1
        while (iterator >= 0 && !collided(board.board[iterator][file])) {
            possibleMoves.add(board.board[iterator][file])
            iterator--
        }
        // Going down
        iterator = rank+1
        while (iterator <= 7 && !collided(board.board[iterator][file])) {
            possibleMoves.add(board.board[iterator][file])
            iterator++
        }

        return possibleMoves
    }

    override fun possibleCaptureMoves(board: Board): List<Spot> {
        val possibleCaptureMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going left side
        var iterator = file-1
        while (iterator >= 0 && !collided(board.board[rank][iterator])) iterator--
        if (iterator >= 0 && this.isWhite != board.board[rank][iterator].piece.isWhite) possibleCaptureMoves.add(board.board[rank][iterator])
        // Going right side
        iterator = file+1
        while (iterator <= 7 && !collided(board.board[rank][iterator])) iterator++
        if (iterator <= 7 && this.isWhite != board.board[rank][iterator].piece.isWhite) possibleCaptureMoves.add(board.board[rank][iterator])
        // Going up
        iterator = rank-1
        while (iterator >= 0 && !collided(board.board[iterator][file])) iterator--
        if (iterator >= 0 && this.isWhite != board.board[iterator][file].piece.isWhite) possibleCaptureMoves.add(board.board[iterator][file])
        // Going down
        iterator = rank+1
        while (iterator <= 7 && !collided(board.board[iterator][file])) iterator++
        if (iterator <= 7 && this.isWhite != board.board[iterator][file].piece.isWhite) possibleCaptureMoves.add(board.board[iterator][file])

        return possibleCaptureMoves
    }

    /**
     * Checks if the given piece is empty
     */
    private fun collided(spot: Spot): Boolean {
        return spot.piece::class != Empty::class
    }
}


class Knight(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = if (isWhite!!) 'N' else 'n'

    override fun possibleMoves(board: Board): List<Spot> {
        val possibleMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going up
        if (rank+2 <= 7) {
            if (file-1 >= 0 && !collided(board.board[rank+2][file-1])) possibleMoves.add(board.board[rank+2][file-1])
            if (file+1 <= 7 && !collided(board.board[rank+2][file+1])) possibleMoves.add(board.board[rank+2][file+1])
        }
        // Going down
        if (rank-2 >= 0) {
            if (file-1 >= 0 && !collided(board.board[rank-2][file-1])) possibleMoves.add(board.board[rank-2][file-1])
            if (file+1 <= 7 && !collided(board.board[rank-2][file+1])) possibleMoves.add(board.board[rank-2][file+1])
        }
        // Going left
        if (file-2 >= 0) {
            if (rank-1 >= 0 && !collided(board.board[rank-1][file-2])) possibleMoves.add(board.board[rank-1][file-2])
            if (rank+1 <= 7 && !collided(board.board[rank+1][file-2])) possibleMoves.add(board.board[rank+1][file-2])
        }
        // Going right
        if (file+2 <= 7) {
            if (rank-1 >= 0 && !collided(board.board[rank-1][file+2])) possibleMoves.add(board.board[rank-1][file+2])
            if (rank+1 <= 7 && !collided(board.board[rank+1][file+2])) possibleMoves.add(board.board[rank+1][file+2])
        }

        return possibleMoves
    }

    override fun possibleCaptureMoves(board: Board): List<Spot> {
        val possibleCaptureMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going up
        if (rank+2 <= 7) {
            if (file-1 >= 0 && collided(board.board[rank+2][file-1]) && this.isWhite != board.board[rank+2][file-1].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank+2][file-1])
            if (file+1 <= 7 && collided(board.board[rank+2][file+1]) && this.isWhite != board.board[rank+2][file+1].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank+2][file+1])
        }
        // Going down
        if (rank-2 >= 0) {
            if (file-1 >= 0 && collided(board.board[rank-2][file-1]) && this.isWhite != board.board[rank-2][file-1].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank-2][file-1])
            if (file+1 <= 7 && collided(board.board[rank-2][file+1]) && this.isWhite != board.board[rank-2][file+1].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank-2][file+1])
        }
        // Going left
        if (file-2 >= 0) {
            if (rank-1 >= 0 && collided(board.board[rank-1][file-2]) && this.isWhite != board.board[rank-1][file-2].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank-1][file-2])
            if (rank+1 <= 7 && collided(board.board[rank+1][file-2]) && this.isWhite != board.board[rank+1][file-2].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank+1][file-2])
        }
        // Going right
        if (file+2 <= 7) {
            if (rank-1 >= 0 && collided(board.board[rank-1][file+2]) && this.isWhite != board.board[rank-1][file+2].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank-1][file+2])
            if (rank+1 <= 7 && collided(board.board[rank+1][file+2]) && this.isWhite != board.board[rank+1][file+2].piece.isWhite)
                possibleCaptureMoves.add(board.board[rank+1][file+2])
        }

        return possibleCaptureMoves
    }

    /**
     * Checks if the given piece is empty
     */
    private fun collided(spot: Spot): Boolean {
        return spot.piece::class != Empty::class
    }
}


class Bishop(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = if (isWhite!!) 'B' else 'b'

    override fun possibleMoves(board: Board): List<Spot> {
        val possibleMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going left primary diagonal
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator--
            rankIterator--
        }
        // Going right primary diagonal
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator++
            rankIterator++
        }
        // Going left secondary diagonal
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator--
            rankIterator++
        }
        // Going right secondary diagonal
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            possibleMoves.add(board.board[rankIterator][fileIterator])
            fileIterator++
            rankIterator--
        }

        return possibleMoves
    }

    override fun possibleCaptureMoves(board: Board): List<Spot> {
        val possibleCaptureMoves = mutableListOf<Spot>()
        val (rank, file) = board.getPosition(this)  // this piece's coordinates

        // Going left primary diagonal
        var fileIterator = file-1
        var rankIterator = rank-1
        while (fileIterator >= 0 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator--
            rankIterator--
        }
        if (fileIterator >= 0 && rankIterator >= 0 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])
        // Going right primary diagonal
        fileIterator = file+1
        rankIterator = rank+1
        while (fileIterator <= 7 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator++
            rankIterator++
        }
        if (fileIterator <= 7 && rankIterator <= 7 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])
        // Going left secondary diagonal
        fileIterator = file-1
        rankIterator = rank+1
        while (fileIterator >= 0 && rankIterator <= 7 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator--
            rankIterator++
        }
        if (fileIterator >= 0 && rankIterator <= 7 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])
        // Going right secondary diagonal
        fileIterator = file+1
        rankIterator = rank-1
        while (fileIterator <= 7 && rankIterator >= 0 && !collided(board.board[rankIterator][fileIterator])) {
            fileIterator++
            rankIterator--
        }
        if (fileIterator <= 7 && rankIterator >= 0 && this.isWhite != board.board[rankIterator][fileIterator].piece.isWhite)
            possibleCaptureMoves.add(board.board[rankIterator][fileIterator])

        return possibleCaptureMoves
    }

    /**
     * Checks if the given piece is empty
     */
    private fun collided(spot: Spot): Boolean {
        return spot.piece::class != Empty::class
    }
}


class Pawn(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = if (isWhite!!) 'P' else 'p'

    override fun possibleMoves(board: Board): List<Spot> {
        val (rank, file) = board.getPosition(this)  // this piece's coordinates
        val direction = if (this.isWhite!!) -1 else 1  // white moves -1 (upwards), black moves 1 (downwards)

        val spot1 = board.board[rank+direction][file]  // the spot front of it
        if (!isEmptySpot(spot1)) return emptyList()  // if the spot front of it isn't empty then it can't advance
        if (!hasMoved(rank)) {
            val spot2 = board.board[rank+direction*2][file]  // the distant spot
            if (isEmptySpot(spot2)) return listOf(spot1, spot2)  // if it didn't shared_code.move yet, and the second spot is empty too, it can advance 1 or 2 squares
        }
        return listOf(spot1)  // otherwise, it can advance 1 square
    }

    override fun possibleCaptureMoves(board: Board): List<Spot> {
        val (rank, file) = board.getPosition(this)  // this piece's coordinates
        val direction = if (this.isWhite!!) -1 else 1  // white moves -1 (upwards), black moves 1 (downwards)

        val captureList = mutableListOf<Spot>()
        if (file in 0..6) {
            val rightDiagonalSpot = board.board[rank+direction][file+1]
            if (!isEmptySpot(rightDiagonalSpot) && differentColors(rightDiagonalSpot.piece)) captureList.add(rightDiagonalSpot)
            if (board.enPas != "-" && rightDiagonalSpot == board.getSpotById(board.enPas)) captureList.add(rightDiagonalSpot)
        }
        if (file in 1..7) {
            val leftDiagonalSpot = board.board[rank+direction][file-1]
            if (!isEmptySpot(leftDiagonalSpot) && differentColors(leftDiagonalSpot.piece)) captureList.add(leftDiagonalSpot)
            if (board.enPas != "-" && leftDiagonalSpot == board.getSpotById(board.enPas)) captureList.add(leftDiagonalSpot)
        }
        return captureList
    }

    /**
     * Checks whether the selected spot is empty
     */
    private fun isEmptySpot(spot: Spot): Boolean {
        return spot.piece::class == Empty::class
    }

    /**
     * Checks if the current piece's and the target piece's colors are different
     */
    private fun differentColors(piece: Piece): Boolean {
        return this.isWhite!! != piece.isWhite
    }

    /**
     * Checks whether a pawn moved or not.
     */
    private fun hasMoved(rank: Int): Boolean {
        if (this.isWhite!! && rank == 6) return false
        if (!this.isWhite && rank == 1) return false
        return true
    }
}


class Empty(_isWhite: Boolean? = null) : Piece(_isWhite) {
    override val char: Char = '-'
    override fun possibleMoves(board: Board): List<Spot> = emptyList()
    override fun possibleCaptureMoves(board: Board): List<Spot> = emptyList()
}