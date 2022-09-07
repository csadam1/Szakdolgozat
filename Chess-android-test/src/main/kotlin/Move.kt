class Move(_player: Player, _chessNotation: String) {
    val from: String
    val to: String
    val promotion: String?
    val player: Player

    init {
        from = _chessNotation.substring(0, 2)
        to = _chessNotation.substring(2, 4)
        promotion = if (_chessNotation.length == 5) _chessNotation.substring(4, 5) else null
        player = _player
    }
}