package shared_code

class Spot(_piece: Piece = Empty()) {
    var piece: Piece
    val id: String
    var highlighted: Boolean

    /**
     * Static-like variable and function. It gives each spot a common unique id in chess.
     * The id contains a file (a-h) and a rank (1-8).
     *
     * a8 b8 c8 ..
     * a7 b7 ..
     * a6 ..
     * ..
     */
    companion object {
        val setId = mutableListOf('a', '8')
        fun updateIdSetter() {
            if (++setId[0] > 'h') {
                setId[0] = 'a'
                if (--setId[1] < '1') {
                    setId[1] = '8'
                }
            }
        }
    }

    init {
        piece = _piece
        highlighted = false
        id = setId.joinToString("")
        updateIdSetter()
    }
}
