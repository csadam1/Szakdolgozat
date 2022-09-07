class Game(_player1: Player, _player2: Player) {
    val player1: Player
    val player2: Player
    val board: Board
    val moves: MutableList<Move>
    var status: GameStatus

    init {
        player1 = _player1
        player2 = _player2
        board = Board()
        moves = mutableListOf()
        status = GameStatus.ACTIVE
    }

    /**
     * Prints the board
     */
    fun printBoard() {
        board.toPrint()
    }

    /**
     * Prints the IDs of board
     */
    fun printBoardIDs() {
        board.toPrintIDs()
    }

    /**
     * Returns the current player.
     * If white is to move and Player1 is white, then Player1 will be the current player.
     * If black is to move and Player1 is black, then Player1 will be the current player.
     * Otherwise, the Player2 is the current player.
     */
    fun getCurrentPlayer() : Player {
        if (board.side == "w" && player1.isWhite)  return player1
        if (board.side == "b" && !player1.isWhite) return player1
        return player2
    }

    /**
     * Checks if the game is still active.
     */
    fun isGameOver() : Boolean {
        if (status != GameStatus.ACTIVE) return true
        return false
    }

    /**
     * Checks if the move that was made is a promotion.
     */
    fun isPromotion(fromSpot: Spot) : Boolean {
        if (fromSpot.piece::class != Pawn::class) return false

        val (rank, _) = board.getPosition(fromSpot.piece)  // this piece's coordinates
        val direction = if (fromSpot.piece.isWhite!!) -1 else 1  // white moves -1 (upwards), black moves 1 (downwards)
        if (rank+direction==0 || rank+direction==7) return true
        return false
    }

    /**
     * Updates the game status.
     * If a color don't have any possible moves/capture moves AND king is under attack THEN he lost
     * If a color don't have any possible moves/capture moves AND king is NOT under attack THEN draw
     */
    fun updateStatus() {
        val isWhite = board.side == "w"
        val spotsOfPlayer = board.allSpotsOfPlayer(isWhite)
        val allPossibleMoves = mutableListOf<List<Spot>>()

        spotsOfPlayer.forEach{
            allPossibleMoves.add(board.filterNotSafeMoves(it.id, it.piece.possibleMoves(board)))
            allPossibleMoves.add(board.filterNotSafeMoves(it.id, it.piece.possibleCaptureMoves(board)))
        }

        val isKingInCheck = board.isKingUnderCheck(board.allSpotsOfPlayer(!isWhite))
        if (allPossibleMoves.flatten().isEmpty() && !isKingInCheck) status = GameStatus.DRAW
        if (allPossibleMoves.flatten().isEmpty() && isKingInCheck) status = if (isWhite) GameStatus.BLACK_WIN else GameStatus.WHITE_WIN
    }

    /**
     * Shows - or rather highlights - possible safe moves.
     */
    fun showSelectedMoves() {
        println("${board.board.flatten().filter { it.highlighted }.map { it.id }}")
    }
}