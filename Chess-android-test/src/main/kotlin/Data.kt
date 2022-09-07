const val START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
const val CUSTOM_FEN_1  = "7Q/1pp1P3/8/p2P2p1/PP4k1/B2R1p2/3K1p2/5r2 w KQkq - 0 1"
const val CUSTOM_FEN_2  = "rnb1kbnr/ppqP1ppp/P7/1Pp5/4pP2/3p4/2PPP1PP/RNBQKBNR w KQkq f3 0 1"  // Pawn moves
const val CUSTOM_FEN_3  = "rnbq1bnr/1ppp2pp/p1R2p2/8/4R3/8/PPPP1PPP/1NB2BNR w - - 0 1"  // Rook moves
const val CUSTOM_FEN_4  = "rnbq2b1/p1pp3p/8/1p6/1B2p3/3B4/PPP2PPP/RN3N1R w - - 0 1"  // Bishop moves
const val CUSTOM_FEN_5  = "rb2qbr1/pp2pp1p/4p3/5Q2/3Q4/7N/P1P1P1PP/2B1KB2 w - - 0 1"  // Queen moves
const val CUSTOM_FEN_6  = "rnbqkbnr/pppppppp/2N5/PP5N/1P2N3/8/PPP3PP/R1BQKB1R w - - 0 1"  // Knight moves
const val CUSTOM_FEN_7  = "rnbqkbnr/ppp1ppp1/7p/pKP4K/4PPP1/1P1R4/P4K1P/RNQ4B w - - 0 1"  // King moves
const val CUSTOM_FEN_8  = "r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R b KQkq - 0 1"  // Castling update
const val CUSTOM_FEN_9  = "r3k2r/pppp1prp/8/8/8/8/8/R3K2R w KQkq - 0 1"  // Castling move #1
const val CUSTOM_FEN_10 = "r3k2r/pppp1r1p/8/8/8/8/8/R3K2R w KQkq - 0 1"  // Castling move #2
const val CUSTOM_FEN_11 = "r3k2r/ppppr2p/8/8/8/8/8/R3K2R w KQkq - 0 1"  // Castling move #3
const val CUSTOM_FEN_12 = "r3k2r/pppr3p/8/8/8/8/8/R3K2R w KQkq - 0 1"  // Castling move #4
const val CUSTOM_FEN_13 = "r3k2r/ppr4p/8/8/8/8/8/R3K2R w KQkq - 0 1"  // Castling move #5
const val CUSTOM_FEN_14 = "r3k2r/pp2n2p/8/8/8/8/R7/R3K2R w KQkq - 0 1"  // Keep the king safe
const val CUSTOM_FEN_15 = "4k3/pp1rrr2/8/8/8/1P2R2p/P6P/4K3 w - - 0 1"  // Keep the king safe
const val CUSTOM_FEN_16 = "4k3/pp1rrr1p/8/8/8/1P6/P6P/4K3 b - - 0 1"  // Checkmate
const val CUSTOM_FEN_17 = "4k3/1p6/8/8/3r1r2/7p/pr6/4K3 b - - 0 1"  // Stalemate

/** side move testing */
const val TEST_FEN_01 = "8/8/8/8/8/8/8/8 w - - 0 1"
const val TEST_FEN_02 = "8/8/8/8/8/8/8/8 b - - 0 1"

/** castle permission testing */
const val TEST_FEN_03 = "8/8/8/8/8/8/8/8 w KQkq - 0 1"
const val TEST_FEN_04 = "8/8/8/8/8/8/8/8 w KQk - 0 1"
const val TEST_FEN_05 = "8/8/8/8/8/8/8/8 w KQ - 0 1"
const val TEST_FEN_06 = "8/8/8/8/8/8/8/8 w K - 0 1"
const val TEST_FEN_07 = "8/8/8/8/8/8/8/8 w - - 0 1"

/** En Passant square testing */
const val TEST_FEN_08 = "8/8/8/8/8/8/8/8 w - e3 0 1"
const val TEST_FEN_09 = "8/8/8/8/8/8/8/8 w - a5 0 1"
const val TEST_FEN_10 = "8/8/8/8/8/8/8/8 w - h4 0 1"

/** Half move testing */
const val TEST_FEN_11 = "8/8/8/8/8/8/8/8 w - - 7 1"
const val TEST_FEN_12 = "8/8/8/8/8/8/8/8 w - - 4 1"
const val TEST_FEN_13 = "8/8/8/8/8/8/8/8 w - - 2022 1"

/** Full move testing */
const val TEST_FEN_14 = "8/8/8/8/8/8/8/8 w - - 0 1"
const val TEST_FEN_15 = "8/8/8/8/8/8/8/8 w - - 0 3"
const val TEST_FEN_16 = "8/8/8/8/8/8/8/8 w - - 0 12"

/** Board testing */
const val TEST_FEN_17 = "n2r3N/5n2/P4p2/6k1/1PQp4/2PR2P1/1P1Kb3/8 w - - 0 1"
const val TEST_FEN_18 = "8/7p/4pK2/p7/1P1kp1PP/4b3/1q1N1NQ1/B3n3 w - - 0 1"

/** Castling testing */
const val TEST_FEN_19 = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/R3KBNR w KQkq - 0 1"  // white Queen-side
const val TEST_FEN_20 = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQK2R w KQkq - 0 1"  // white King-side
const val TEST_FEN_21 = "r3kbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"  // black Queen-side
const val TEST_FEN_22 = "rnbqk2r/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"  // black King-side

const val RANKS = 8
const val FILES = 8

enum class GameStatus {
    ACTIVE, DRAW, WHITE_WIN, BLACK_WIN
}

fun Number.inc(): Number {
    return (this.toInt()+1)
}