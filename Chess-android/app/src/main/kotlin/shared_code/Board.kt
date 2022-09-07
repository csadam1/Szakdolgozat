package shared_code

class Board {
    val board = Array(RANKS) { Array(FILES) { Spot() } }

    lateinit var side: String
    lateinit var enPas: String
    lateinit var castPerm: String
    lateinit var halfMove: Number
    lateinit var fullMove: Number

    /**
     * Setting up the board manually
     */
    init {
        parseFEN()
    }

    /**
     * Prints the board.
     */
    fun toPrint() {
        print("\n\n")
        board.forEach { row ->
            val ranks = row[0].id[1]  // contains the ranks (numbers)
            val spotsInARow = row.joinToString("  ") { spot -> spot.piece.char.toString() } // contains 1 row of spots and pieces

            println("""
                $ranks   $spotsInARow
            """.trimIndent())
        }
        val files = board[0].joinToString("  ") { it.id[0].toString() }  // contains the files (letters)
        println("\n    $files\n")

        println("""
            Side: $side
            En Passant: $enPas
            Castling Permission: $castPerm
        """.trimIndent())
    }

    fun toPrintIDs() {
        board.forEach { row ->
            row.forEach { spot ->
                print("${spot.id} ")
            }
            println()
        }
    }

    /**
     * Parses the string FEN to an actual board position.
     *
     *  - 1st field:
     *    - It has 7 slashes
     *    - It has exactly 8 fields
     *
     *  - 2nd field:
     *    - It has 1 character, either 'w' or 'b'
     *
     *  - 3rd field:
     *    - It can have 5 different characters, which can appear only once in this order: 'KQkq-'
     *
     *  - 4th field:
     *    - There is either a square id (i.e. 'c6') or a hyphen
     *
     *  - 5th field:
     *    - A number, between 0 and 50
     *    - It must reset to 0 if a piece is captured or a pawn advanced.
     *
     *  - 6th field:
     *    - a non-negative number, incremented by 1 after the black's shared_code.move
     */
    fun parseFEN(customStringFEN: String = START_FEN) {
        val customFEN = customStringFEN.split(" ")
        var rowIterator = 0
        var colIterator = 0

        customFEN[0].forEach { char ->
            when (char) {
                'P' -> board[rowIterator][colIterator].piece = Pawn(true)
                'p' -> board[rowIterator][colIterator].piece = Pawn(false)
                'R' -> board[rowIterator][colIterator].piece = Rook(true)
                'r' -> board[rowIterator][colIterator].piece = Rook(false)
                'N' -> board[rowIterator][colIterator].piece = Knight(true)
                'n' -> board[rowIterator][colIterator].piece = Knight(false)
                'B' -> board[rowIterator][colIterator].piece = Bishop(true)
                'b' -> board[rowIterator][colIterator].piece = Bishop(false)
                'K' -> board[rowIterator][colIterator].piece = King(true)
                'k' -> board[rowIterator][colIterator].piece = King(false)
                'Q' -> board[rowIterator][colIterator].piece = Queen(true)
                'q' -> board[rowIterator][colIterator].piece = Queen(false)
                '/' -> { rowIterator++; colIterator=-1 }
                else -> colIterator+=char.digitToInt()-1
            }
            colIterator++
        }

        side = customFEN[1]  /** Adding the current side */
        castPerm = customFEN[2]  /** Adding Castling Permissions */
        enPas = customFEN[3]  /** Adding En Passant square if available */
        halfMove = customFEN[4].toInt()
        fullMove = customFEN[5].toInt()
    }

    /**
     * Executes the player's shared_code.move and updates the board accordingly.
     */
    fun makeMove(move: Move) {
        // Decides if it's a capture shared_code.move
        var capture = getSpotById(move.to).piece::class != Empty::class

        // Get the piece from the 'shared_code.move.from' square. Saving it in a temporary variable
        val movingPiece = getSpotById(move.from).piece
        // Clear the spot
        getSpotById(move.from).piece = Empty()
        // shared_code.Move the piece to 'to' spot
        getSpotById(move.to).piece = movingPiece

        // If it's an En Passant capture shared_code.move, the other player's piece is set to empty
        if (isEnPasMove(move.to, movingPiece)) {
            capture = true
            captureEnPas(move)
        }
        // If it's a promotion shared_code.move, replace the current pawn with the selected piece
        if (isPromotionMove(move)) {
            promotePawn(getSpotById(move.to), move.promotion!!)
        }
        // If it's a castling shared_code.move, replace the rook to the correct position
        if (isCastlingMove(move)) {
            replaceRook(move)
        }

        // Updates the board data
        side = if (side == "w") "b" else "w"
        enPas = updateEnPas(movingPiece, move)
        castPerm = updateCastPerm(castPerm)
        halfMove = updateHalfMove(movingPiece, capture)
        fullMove = updateFullMove()
    }

    /**
     * If it's a castling shared_code.move, replaces the rook based on where the shared_code.King made the castling shared_code.move.
     */
    fun replaceRook(move: Move) {
        if (move.player.isWhite && move.from == "e1" && move.to == "c1" && 'Q' in castPerm) {
            val rookTemp = board[7][0].piece
            board[7][0].piece = Empty()
            board[7][3].piece = rookTemp
        }
        if (move.player.isWhite && move.from == "e1" && move.to == "g1" && 'K' in castPerm) {
            val rookTemp = board[7][7].piece
            board[7][7].piece = Empty()
            board[7][5].piece = rookTemp
        }
        if (!move.player.isWhite && move.from == "e8" && move.to == "c8" && 'q' in castPerm) {
            val rookTemp = board[0][0].piece
            board[0][0].piece = Empty()
            board[0][3].piece = rookTemp
        }
        if (!move.player.isWhite && move.from == "e8" && move.to == "g8" && 'k' in castPerm) {
            val rookTemp = board[0][7].piece
            board[0][7].piece = Empty()
            board[0][5].piece = rookTemp
        }
    }

    /**
     * Checks if the shared_code.move is a castling shared_code.move.
     */
    fun isCastlingMove(move: Move): Boolean {
        if ('-' in castPerm) return false
        if (move.player.isWhite && move.from == "e1" && move.to == "c1" && 'Q' in castPerm) return true
        if (move.player.isWhite && move.from == "e1" && move.to == "g1" && 'K' in castPerm) return true
        if (!move.player.isWhite && move.from == "e8" && move.to == "c8" && 'q' in castPerm) return true
        if (!move.player.isWhite && move.from == "e8" && move.to == "g8" && 'k' in castPerm) return true
        return false
    }

    /**
     * Checks if the shared_code.move is promotion shared_code.move
     */
    fun isPromotionMove(move: Move): Boolean {
        return move.promotion != null
    }

    /**
     * Replaces the promoted pawn with the selected piece.
     */
    fun promotePawn(spot: Spot, promotion: String) {
        if (promotion == "q") spot.piece = if (side == "w") Queen(true) else Queen(false)
        if (promotion == "r") spot.piece = if (side == "w") Rook(true) else Rook(false)
        if (promotion == "n") spot.piece = if (side == "w") Knight(true) else Knight(false)
        if (promotion == "b") spot.piece = if (side == "w") Bishop(true) else Bishop(false)
    }

    /**
     * Decides if the shared_code.move was an En Passant capture shared_code.move.
     */
    fun isEnPasMove(toSquare: String, piece: Piece): Boolean {
        return toSquare == enPas && piece::class == Pawn::class
    }

    /**
     * The function removes the opponent's piece from an En Passant shared_code.move
     */
    fun captureEnPas(move: Move) {
        val direction = if (move.player.isWhite) 1 else -1
        val (rank, file) = getPosition(getSpotById(move.to).piece)
        board[rank+direction][file].piece = Empty()
    }

    /**
     * After the black moved it increments itself by 1.
     */
    fun updateFullMove(): Number {
        if (side == "w") return this.fullMove.inc()
        return this.fullMove
    }

    /**
     * Resets half moves if it's a pawn shared_code.move or a piece is captured, otherwise it's value is incremented by 1.
     */
    fun updateHalfMove(piece: Piece, capture: Boolean): Number {
        if (piece::class == Pawn::class || capture) return 0
        return this.halfMove.inc()
    }

    /**
     * Checks if the Castling Permissions are still active.
     * The rules: https://www.flyordie.com/games/help/chess/en/games_rules_chess.html#castling
     */
    fun updateCastPerm(castPerm: String): String {
        if (castPerm == "-") return castPerm
        var castPerm2 = if (board[7][0].piece::class != Rook::class) castPerm.filterNot { it == 'Q' } else castPerm
        castPerm2 = if (board[7][7].piece::class != Rook::class) castPerm2.filterNot { it == 'K' } else castPerm2
        castPerm2 = if (board[7][4].piece::class != King::class) castPerm2.filterNot { it == 'K' || it == 'Q' } else castPerm2
        castPerm2 = if (board[0][0].piece::class != Rook::class) castPerm2.filterNot { it == 'q' } else castPerm2
        castPerm2 = if (board[0][7].piece::class != Rook::class) castPerm2.filterNot { it == 'k' } else castPerm2
        castPerm2 = if (board[0][4].piece::class != King::class) castPerm2.filterNot { it == 'k' || it == 'q' } else castPerm2
        if (castPerm2.isEmpty()) castPerm2 = "-"
        return castPerm2
    }

    /**
     * Checks if there is an En Passant square
     */
    fun updateEnPas(piece: Piece, move: Move): String {
        if (piece::class != Pawn::class) return "-"
        if (piece.isWhite!! && move.from in board[6].map { it.id } && move.to in board[4].map { it.id })
            return move.from.toMutableList()[0] + move.from.toMutableList()[1].inc().toString()
        if (!piece.isWhite && move.from in board[1].map { it.id } && move.to in board[3].map { it.id })
            return move.from.toMutableList()[0] + move.from.toMutableList()[1].dec().toString()
        return "-"
    }

    /**
     * Returns the spot by its ID.
     */
    fun getSpotById(id: String): Spot {
        return board.flatten().find { it.id == id }!!
    }

    /**
     * Returns the piece's current position on the matrix. It finds in which rank and file the piece is.
     */
    fun getPosition(piece: Piece): Pair<Int, Int> {
        val rankIndex = board.indexOf(
                this.board
                    .find { rank -> rank.find { spot -> spot.piece == piece } != null }!!
            )
        val fileIndex = board[rankIndex].indexOf(
                this.board[rankIndex]
                    .find { spot -> spot.piece == piece }
            )
        return Pair(rankIndex, fileIndex)
    }

    /**
     * A move is not safe if after that the King would be in check.
     * Checks if the selected spot is under attack by the other side.
     *   - saving the piece on the spot
     *   - moving the king to the selected spot
     *   - checking if the king is in check now
     *   - resetting the table
     */
    fun filterNotSafeMoves(from: String, moveList: List<Spot>): List<Spot> {
        return moveList.filter { toSpot ->
            val to = toSpot.id
            // saving the piece on the spot
            val saveFromPiece = getSpotById(from).piece
            val saveToPiece = getSpotById(to).piece

            // moving the king to the selected spot
            getSpotById(to).piece = getSpotById(from).piece
            getSpotById(from).piece = Empty()

            // checking if the king is in check now
            val enemySpotList = allSpotsOfPlayer(!getSpotById(to).piece.isWhite!!)
            val kingUnderAttack = isKingUnderCheck(enemySpotList)

            // resetting the table
            getSpotById(from).piece = saveFromPiece
            getSpotById(to).piece = saveToPiece

            return@filter !kingUnderAttack
        }
    }

    /**
     * Checks if the shared_code.King is under attack.
     */
    fun isKingUnderCheck(enemySpotList: List<Spot>): Boolean {
        return King::class in enemySpotList.map { it.piece.possibleCaptureMoves(this).map { innerIt -> innerIt.piece::class } }.flatten()
    }

    /**
     * The function collects all the pieces of a player.
     */
    fun allSpotsOfPlayer(isWhite: Boolean): List<Spot> {
        return board.map { rank ->
            rank.filter { it.piece::class != Empty::class && isWhite == it.piece.isWhite }
        }.filterNot { it == emptyList<Spot>() }.flatten()
    }
}


