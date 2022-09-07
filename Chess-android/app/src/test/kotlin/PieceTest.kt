import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import shared_code.*

class PieceTest {
    val board = Board()

    @Nested
    inner class King {
        init {
            board.board.forEach { row ->
                row.forEach { spot ->
                    spot.piece = Empty(null)
                }
            }
            board.getSpotById("e8").piece = King(false)
            board.getSpotById("e4").piece = King(true)
            board.getSpotById("h8").piece = King(true)
            board.getSpotById("a1").piece = King(true)

            board.castPerm = "-"
        }

        @Nested
        inner class Constructor {
            @Test
            fun `check if the character of white king is 'K'`() {
                val kingP = King(true)
                assertEquals('K', kingP.char)
            }

            @Test
            fun `check if the character of black king is 'k'`() {
                val kingP = King(false)
                assertEquals('k', kingP.char)
            }
        }

        @Nested
        inner class PossibleMoves {
            @Test
            fun `check if king can step without going out of table`() {
                val expectedValueList1 = listOf(
                    board.getSpotById("d5"), board.getSpotById("e5"), board.getSpotById("f5"),
                    board.getSpotById("d4"),                              board.getSpotById("f4"),
                    board.getSpotById("d3"), board.getSpotById("e3"), board.getSpotById("f3")
                ).toSet()
                val moveList1 = board.getSpotById("e4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList1, moveList1)

                val expectedValueList2 = listOf(
                    board.getSpotById("g8"), board.getSpotById("g7"), board.getSpotById("h7")
                ).toSet()
                val moveList2 = board.getSpotById("h8").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList2, moveList2)

                val expectedValueList3 = listOf(
                    board.getSpotById("a2"), board.getSpotById("b2"), board.getSpotById("b1")
                ).toSet()
                val moveList3 = board.getSpotById("a1").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if king can step without hitting any friendly piece`() {
                board.getSpotById("d5").piece = Pawn(true)
                board.getSpotById("e5").piece = Pawn(true)
                board.getSpotById("f5").piece = Pawn(true)

                board.getSpotById("d4").piece = Pawn(true)
                board.getSpotById("f4").piece = Pawn(true)

                board.getSpotById("d3").piece = Pawn(true)
                board.getSpotById("e3").piece = Pawn(true)
                board.getSpotById("f3").piece = Pawn(true)

                val expectedValueList1 = emptyList<Spot>()
                val moveList1 = board.getSpotById("e4").piece.possibleMoves(board)
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("g8").piece = Pawn(true)
                board.getSpotById("g7").piece = Pawn(true)
                board.getSpotById("h7").piece = Pawn(true)

                val expectedValueList2 = emptyList<Spot>()
                val moveList2 = board.getSpotById("h8").piece.possibleMoves(board)
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("a2").piece = Pawn(true)
                board.getSpotById("b2").piece = Pawn(true)
                board.getSpotById("b1").piece = Pawn(true)

                val expectedValueList3 = emptyList<Spot>()
                val moveList3 = board.getSpotById("a1").piece.possibleMoves(board)
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if king can step without hitting any enemy piece`() {
                board.getSpotById("d5").piece = Pawn(false)
                board.getSpotById("e5").piece = Pawn(false)
                board.getSpotById("f5").piece = Pawn(false)

                board.getSpotById("d4").piece = Pawn(false)
                board.getSpotById("f4").piece = Pawn(false)

                board.getSpotById("d3").piece = Pawn(false)
                board.getSpotById("e3").piece = Pawn(false)
                board.getSpotById("f3").piece = Pawn(false)

                val expectedValueList1 = emptyList<Spot>()
                val moveList1 = board.getSpotById("e4").piece.possibleMoves(board)
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("g8").piece = Pawn(false)
                board.getSpotById("g7").piece = Pawn(false)
                board.getSpotById("h7").piece = Pawn(false)

                val expectedValueList2 = emptyList<Spot>()
                val moveList2 = board.getSpotById("h8").piece.possibleMoves(board)
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("a2").piece = Pawn(false)
                board.getSpotById("b2").piece = Pawn(false)
                board.getSpotById("b1").piece = Pawn(false)

                val expectedValueList3 = emptyList<Spot>()
                val moveList3 = board.getSpotById("a1").piece.possibleMoves(board)
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if castle permission works well`() {
                board.getSpotById("a1").piece = Rook(true)
                board.getSpotById("h1").piece = Rook(true)
                board.getSpotById("e1").piece = King(true)
                board.castPerm = "KQ"

                val expectedValueList = listOf(board.getSpotById("c1"), board.getSpotById("g1")).toSet()
                val moveList = board.getSpotById("e1").piece.possibleMoves(board).toSet()
                assertTrue(moveList.containsAll(expectedValueList))
            }
        }

        @Nested
        inner class PossibleCaptureMoves {
            @Test
            fun `check if king can not capture friendly pieces`() {
                board.getSpotById("d5").piece = Pawn(true)
                board.getSpotById("e5").piece = Pawn(true)
                board.getSpotById("f5").piece = Pawn(true)

                board.getSpotById("d4").piece = Pawn(true)
                board.getSpotById("f4").piece = Pawn(true)

                board.getSpotById("d3").piece = Pawn(true)
                board.getSpotById("e3").piece = Pawn(true)
                board.getSpotById("f3").piece = Pawn(true)

                val expectedValueList1 = emptyList<Spot>()
                val moveList1 = board.getSpotById("e4").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("g8").piece = Pawn(true)
                board.getSpotById("g7").piece = Pawn(true)
                board.getSpotById("h7").piece = Pawn(true)

                val expectedValueList2 = emptyList<Spot>()
                val moveList2 = board.getSpotById("h8").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("a2").piece = Pawn(true)
                board.getSpotById("b2").piece = Pawn(true)
                board.getSpotById("b1").piece = Pawn(true)

                val expectedValueList3 = emptyList<Spot>()
                val moveList3 = board.getSpotById("a1").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if king can capture enemy pieces`() {
                board.getSpotById("d5").piece = Pawn(false)
                board.getSpotById("e5").piece = Pawn(false)
                board.getSpotById("f5").piece = Pawn(false)

                board.getSpotById("d4").piece = Pawn(false)
                board.getSpotById("f4").piece = Pawn(false)

                board.getSpotById("d3").piece = Pawn(false)
                board.getSpotById("e3").piece = Pawn(false)
                board.getSpotById("f3").piece = Pawn(false)

                val expectedValueList1 = listOf(
                    board.getSpotById("d5"),
                    board.getSpotById("e5"),
                    board.getSpotById("f5"),
                    board.getSpotById("d4"),
                    board.getSpotById("f4"),
                    board.getSpotById("d3"),
                    board.getSpotById("e3"),
                    board.getSpotById("f3")
                ).toSet()
                val moveList1 = board.getSpotById("e4").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("g8").piece = Pawn(false)
                board.getSpotById("g7").piece = Pawn(false)
                board.getSpotById("h7").piece = Pawn(false)

                val expectedValueList2 = listOf(
                    board.getSpotById("g8"),
                    board.getSpotById("g7"),
                    board.getSpotById("h7")
                ).toSet()
                val moveList2 = board.getSpotById("h8").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("a2").piece = Pawn(false)
                board.getSpotById("b2").piece = Pawn(false)
                board.getSpotById("b1").piece = Pawn(false)

                val expectedValueList3 = listOf(
                    board.getSpotById("a2"),
                    board.getSpotById("b2"),
                    board.getSpotById("b1")
                ).toSet()
                val moveList3 = board.getSpotById("a1").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList3, moveList3)
            }
        }
    }

    @Nested
    inner class Queen {
        init {
            board.board.forEach { row ->
                row.forEach { spot ->
                    if (spot.piece::class != King::class) spot.piece = Empty(null)
                }
            }
            board.getSpotById("d4").piece = Queen(true)
        }

        @Nested
        inner class Constructor {
            @Test
            fun `check if the character of white queen is 'Q'`() {
                val queenP = Queen(true)
                assertEquals('Q', queenP.char)
            }

            @Test
            fun `check if the character of black queen is 'q'`() {
                val queenP = Queen(false)
                assertEquals('q', queenP.char)
            }
        }

        @Nested
        inner class PossibleMoves {
            @Test
            fun `check if queen can go horizontal, vertical and diagonal without going out of table`() {
                val expectedValueList = listOf(
                    board.getSpotById("d5"), board.getSpotById("d6"), board.getSpotById("d7"), board.getSpotById("d8"),
                    board.getSpotById("d3"), board.getSpotById("d2"), board.getSpotById("d1"),
                    board.getSpotById("c4"), board.getSpotById("b4"), board.getSpotById("a4"),
                    board.getSpotById("e4"), board.getSpotById("f4"), board.getSpotById("g4"), board.getSpotById("h4"),

                    board.getSpotById("c5"), board.getSpotById("b6"), board.getSpotById("a7"),
                    board.getSpotById("c3"), board.getSpotById("b2"), board.getSpotById("a1"),
                    board.getSpotById("e3"), board.getSpotById("f2"), board.getSpotById("g1"),
                    board.getSpotById("e5"), board.getSpotById("f6"), board.getSpotById("g7"), board.getSpotById("h8")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if queen can go horizontal, vertical and diagonal without going through or hitting any friendly piece`() {
                board.getSpotById("d2").piece = Pawn(true)
                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("g4").piece = Pawn(true)
                board.getSpotById("b4").piece = Pawn(true)

                board.getSpotById("b6").piece = Pawn(true)
                board.getSpotById("g7").piece = Pawn(true)
                board.getSpotById("f2").piece = Pawn(true)
                board.getSpotById("c3").piece = Pawn(true)

                val expectedValueList = listOf(
                    board.getSpotById("d5"),
                    board.getSpotById("d3"),
                    board.getSpotById("c4"),
                    board.getSpotById("e4"), board.getSpotById("f4"),

                    board.getSpotById("c5"),

                    board.getSpotById("e3"),
                    board.getSpotById("e5"), board.getSpotById("f6")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if queen can go horizontal, vertical and diagonal without going through or hitting any enemy piece`() {
                board.getSpotById("d2").piece = Pawn(false)
                board.getSpotById("d6").piece = Pawn(false)
                board.getSpotById("g4").piece = Pawn(false)
                board.getSpotById("b4").piece = Pawn(false)

                board.getSpotById("b6").piece = Pawn(false)
                board.getSpotById("g7").piece = Pawn(false)
                board.getSpotById("f2").piece = Pawn(false)
                board.getSpotById("c3").piece = Pawn(false)

                val expectedValueList = listOf(
                    board.getSpotById("d5"),
                    board.getSpotById("d3"),
                    board.getSpotById("c4"),
                    board.getSpotById("e4"), board.getSpotById("f4"),

                    board.getSpotById("c5"),

                    board.getSpotById("e3"),
                    board.getSpotById("e5"), board.getSpotById("f6")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }
        }

        @Nested
        inner class PossibleCaptureMoves {
            @Test
            fun `check if queen can not capture friendly pieces`() {
                board.getSpotById("d2").piece = Pawn(true)
                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("g4").piece = Pawn(true)
                board.getSpotById("b4").piece = Pawn(true)

                board.getSpotById("b6").piece = Pawn(true)
                board.getSpotById("g7").piece = Pawn(true)
                board.getSpotById("f2").piece = Pawn(true)
                board.getSpotById("c3").piece = Pawn(true)

                val expectedValueList = emptyList<Spot>()
                val moveList = board.getSpotById("d4").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if queen can capture enemy pieces`() {
                board.getSpotById("d2").piece = Pawn(false)
                board.getSpotById("d6").piece = Pawn(false)
                board.getSpotById("g4").piece = Pawn(false)
                board.getSpotById("b4").piece = Pawn(false)

                board.getSpotById("b6").piece = Pawn(false)
                board.getSpotById("g7").piece = Pawn(false)
                board.getSpotById("f2").piece = Pawn(false)
                board.getSpotById("c3").piece = Pawn(false)

                val expectedValueList = listOf(
                    board.getSpotById("d2"),
                    board.getSpotById("d6"),
                    board.getSpotById("g4"),
                    board.getSpotById("b4"),
                    board.getSpotById("b6"),
                    board.getSpotById("g7"),
                    board.getSpotById("f2"),
                    board.getSpotById("c3")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }
        }
    }

    @Nested
    inner class Rook {
        init {
            board.board.forEach { row ->
                row.forEach { spot ->
                    if (spot.piece::class != King::class) spot.piece = Empty(null)
                }
            }
            board.getSpotById("d4").piece = Rook(true)
        }

        @Nested
        inner class Constructor {
            @Test
            fun `check if the character of white rook is 'R'`() {
                val rookP = Rook(true)
                assertEquals('R', rookP.char)
            }

            @Test
            fun `check if the character of black rook is 'r'`() {
                val rookP = Rook(false)
                assertEquals('r', rookP.char)
            }
        }

        @Nested
        inner class PossibleMoves {
            @Test
            fun `check if rook can go horizontal and vertical without going out of table`() {
                val expectedValueList = listOf(
                    board.getSpotById("d5"), board.getSpotById("d6"), board.getSpotById("d7"), board.getSpotById("d8"),
                    board.getSpotById("d3"), board.getSpotById("d2"), board.getSpotById("d1"),
                    board.getSpotById("c4"), board.getSpotById("b4"), board.getSpotById("a4"),
                    board.getSpotById("e4"), board.getSpotById("f4"), board.getSpotById("g4"), board.getSpotById("h4")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if rook can go horizontal and vertical without going through or hitting any friendly piece`() {
                board.getSpotById("d2").piece = Pawn(true)
                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("g4").piece = Pawn(true)
                board.getSpotById("b4").piece = Pawn(true)

                val expectedValueList = listOf(
                    board.getSpotById("d5"),
                    board.getSpotById("d3"),
                    board.getSpotById("c4"),
                    board.getSpotById("e4"), board.getSpotById("f4")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if rook can go horizontal and vertical without going through or hitting any enemy piece`() {
                board.getSpotById("d2").piece = Pawn(false)
                board.getSpotById("d6").piece = Pawn(false)
                board.getSpotById("g4").piece = Pawn(false)
                board.getSpotById("b4").piece = Pawn(false)

                val expectedValueList = listOf(
                    board.getSpotById("d5"),
                    board.getSpotById("d3"),
                    board.getSpotById("c4"),
                    board.getSpotById("e4"), board.getSpotById("f4")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }
        }

        @Nested
        inner class PossibleCaptureMoves {
            @Test
            fun `check if rook can not capture friendly pieces`() {
                board.getSpotById("d2").piece = Pawn(true)
                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("g4").piece = Pawn(true)
                board.getSpotById("b4").piece = Pawn(true)

                val expectedValueList = emptyList<Spot>()
                val moveList = board.getSpotById("d4").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if rook can capture enemy pieces`() {
                board.getSpotById("d2").piece = Pawn(false)
                board.getSpotById("d6").piece = Pawn(false)
                board.getSpotById("g4").piece = Pawn(false)
                board.getSpotById("b4").piece = Pawn(false)

                val expectedValueList = listOf(
                    board.getSpotById("d2"),
                    board.getSpotById("d6"),
                    board.getSpotById("g4"),
                    board.getSpotById("b4")
                ).toSet()
                val moveList = board.getSpotById("d4").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }
        }
    }

    @Nested
    inner class Knight {
        init {
            board.board.forEach { row ->
                row.forEach { spot ->
                    if (spot.piece::class != King::class) spot.piece = Empty(null)
                }
            }
            board.getSpotById("e4").piece = Knight(true)
            board.getSpotById("a1").piece = Knight(true)
            board.getSpotById("h8").piece = Knight(true)
        }

        @Nested
        inner class Constructor {
            @Test
            fun `check if the character of white knight is 'N'`() {
                val knightP = Knight(true)
                assertEquals('N', knightP.char)
            }

            @Test
            fun `check if the character of black knight is 'n'`() {
                val knightP = Knight(false)
                assertEquals('n', knightP.char)
            }
        }

        @Nested
        inner class PossibleMoves {
            @Test
            fun `check if knight can jump in an L shape without going out of table`() {
                val expectedValueList1 = listOf(
                    board.getSpotById("d6"), board.getSpotById("f6"),
                    board.getSpotById("c5"), board.getSpotById("g5"),
                    board.getSpotById("c3"), board.getSpotById("g3"),
                    board.getSpotById("d2"), board.getSpotById("f2")
                ).toSet()
                val moveList1 = board.getSpotById("e4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList1, moveList1)

                val expectedValueList2 = listOf(
                    board.getSpotById("f7"), board.getSpotById("g6")
                ).toSet()
                val moveList2 = board.getSpotById("h8").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList2, moveList2)

                val expectedValueList3 = listOf(
                    board.getSpotById("b3"), board.getSpotById("c2")
                ).toSet()
                val moveList3 = board.getSpotById("a1").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if knight can jump in an L shape without hitting any friendly piece`() {
                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("f6").piece = Pawn(true)
                board.getSpotById("c5").piece = Pawn(true)
                board.getSpotById("g5").piece = Pawn(true)
                board.getSpotById("c3").piece = Pawn(true)
                board.getSpotById("g3").piece = Pawn(true)
                board.getSpotById("d2").piece = Pawn(true)
                board.getSpotById("f2").piece = Pawn(true)

                val expectedValueList1 = emptyList<Spot>()
                val moveList1 = board.getSpotById("e4").piece.possibleMoves(board)
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("f7").piece = Pawn(true)
                board.getSpotById("g6").piece = Pawn(true)

                val expectedValueList2 = emptyList<Spot>()
                val moveList2 = board.getSpotById("h8").piece.possibleMoves(board)
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("b3").piece = Pawn(true)
                board.getSpotById("c2").piece = Pawn(true)

                val expectedValueList3 = emptyList<Spot>()
                val moveList3 = board.getSpotById("a1").piece.possibleMoves(board)
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if knight can jump in an L shape without hitting any enemy piece`() {
                board.getSpotById("d6").piece = Pawn(false)
                board.getSpotById("f6").piece = Pawn(false)
                board.getSpotById("c5").piece = Pawn(false)
                board.getSpotById("g5").piece = Pawn(false)
                board.getSpotById("c3").piece = Pawn(false)
                board.getSpotById("g3").piece = Pawn(false)
                board.getSpotById("d2").piece = Pawn(false)
                board.getSpotById("f2").piece = Pawn(false)

                val expectedValueList1 = emptyList<Spot>()
                val moveList1 = board.getSpotById("e4").piece.possibleMoves(board)
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("f7").piece = Pawn(false)
                board.getSpotById("g6").piece = Pawn(false)

                val expectedValueList2 = emptyList<Spot>()
                val moveList2 = board.getSpotById("h8").piece.possibleMoves(board)
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("b3").piece = Pawn(false)
                board.getSpotById("c2").piece = Pawn(false)

                val expectedValueList3 = emptyList<Spot>()
                val moveList3 = board.getSpotById("a1").piece.possibleMoves(board)
                assertEquals(expectedValueList3, moveList3)
            }
        }

        @Nested
        inner class PossibleCaptureMoves {
            @Test
            fun `check if knight can not capture friendly pieces`() {
                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("f6").piece = Pawn(true)
                board.getSpotById("c5").piece = Pawn(true)
                board.getSpotById("g5").piece = Pawn(true)
                board.getSpotById("c3").piece = Pawn(true)
                board.getSpotById("g3").piece = Pawn(true)
                board.getSpotById("d2").piece = Pawn(true)
                board.getSpotById("f2").piece = Pawn(true)

                val expectedValueList1 = emptyList<Spot>()
                val moveList1 = board.getSpotById("e4").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("f7").piece = Pawn(true)
                board.getSpotById("g6").piece = Pawn(true)

                val expectedValueList2 = emptyList<Spot>()
                val moveList2 = board.getSpotById("h8").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("b3").piece = Pawn(true)
                board.getSpotById("c2").piece = Pawn(true)

                val expectedValueList3 = emptyList<Spot>()
                val moveList3 = board.getSpotById("a1").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList3, moveList3)
            }

            @Test
            fun `check if knight can capture enemy pieces`() {
                board.getSpotById("d6").piece = Pawn(false)
                board.getSpotById("f6").piece = Pawn(false)
                board.getSpotById("c5").piece = Pawn(false)
                board.getSpotById("g5").piece = Pawn(false)
                board.getSpotById("c3").piece = Pawn(false)
                board.getSpotById("g3").piece = Pawn(false)
                board.getSpotById("d2").piece = Pawn(false)
                board.getSpotById("f2").piece = Pawn(false)

                val expectedValueList1 = listOf(
                    board.getSpotById("d6"), board.getSpotById("f6"),
                    board.getSpotById("c5"), board.getSpotById("g5"),
                    board.getSpotById("c3"), board.getSpotById("g3"),
                    board.getSpotById("d2"), board.getSpotById("f2")
                ).toSet()
                val moveList1 = board.getSpotById("e4").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList1, moveList1)

                board.getSpotById("f7").piece = Pawn(false)
                board.getSpotById("g6").piece = Pawn(false)

                val expectedValueList2 = listOf(
                    board.getSpotById("f7"), board.getSpotById("g6")
                ).toSet()
                val moveList2 = board.getSpotById("h8").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList2, moveList2)

                board.getSpotById("b3").piece = Pawn(false)
                board.getSpotById("c2").piece = Pawn(false)

                val expectedValueList3 = listOf(
                    board.getSpotById("b3"), board.getSpotById("c2")
                ).toSet()
                val moveList3 = board.getSpotById("a1").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList3, moveList3)
            }
        }
    }

    @Nested
    inner class Bishop {
        init {
            board.board.forEach { row ->
                row.forEach { spot ->
                    if (spot.piece::class != King::class) spot.piece = Empty(null)
                }
            }
            board.getSpotById("e4").piece = Bishop(true)
        }

        @Nested
        inner class Constructor {
            @Test
            fun `check if the character of white bishop is 'B'`() {
                val bishopP = Bishop(true)
                assertEquals('B', bishopP.char)
            }

            @Test
            fun `check if the character of black bishop is 'b'`() {
                val bishopP = Bishop(false)
                assertEquals('b', bishopP.char)
            }
        }

        @Nested
        inner class PossibleMoves {
            @Test
            fun `check if bishop can go diagonal without going out of table`() {
                val expectedValueList = listOf(
                    board.getSpotById("d5"), board.getSpotById("c6"), board.getSpotById("b7"), board.getSpotById("a8"),
                    board.getSpotById("f5"), board.getSpotById("g6"), board.getSpotById("h7"),
                    board.getSpotById("f3"), board.getSpotById("g2"), board.getSpotById("h1"),
                    board.getSpotById("d3"), board.getSpotById("c2"), board.getSpotById("b1")
                ).toSet()
                val moveList = board.getSpotById("e4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if bishop can go diagonal without going through or hitting any friendly piece`() {
                board.getSpotById("b7").piece = Pawn(true)
                board.getSpotById("g6").piece = Pawn(true)
                board.getSpotById("g2").piece = Pawn(true)
                board.getSpotById("d3").piece = Pawn(true)

                val expectedValueList = listOf(
                    board.getSpotById("d5"), board.getSpotById("c6"),
                    board.getSpotById("f5"),
                    board.getSpotById("f3"),
                ).toSet()
                val moveList = board.getSpotById("e4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if bishop can go diagonal without going through or hitting any enemy piece`() {
                board.getSpotById("b7").piece = Pawn(false)
                board.getSpotById("g6").piece = Pawn(false)
                board.getSpotById("g2").piece = Pawn(false)
                board.getSpotById("d3").piece = Pawn(false)

                val expectedValueList = listOf(
                    board.getSpotById("d5"), board.getSpotById("c6"),
                    board.getSpotById("f5"),
                    board.getSpotById("f3")
                ).toSet()
                val moveList = board.getSpotById("e4").piece.possibleMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }
        }

        @Nested
        inner class PossibleCaptureMoves {
            @Test
            fun `check if bishop can not capture friendly pieces`() {
                board.getSpotById("b7").piece = Pawn(true)
                board.getSpotById("g6").piece = Pawn(true)
                board.getSpotById("g2").piece = Pawn(true)
                board.getSpotById("d3").piece = Pawn(true)

                val expectedValueList = emptyList<Spot>()
                val moveList = board.getSpotById("e4").piece.possibleCaptureMoves(board)
                assertEquals(expectedValueList, moveList)
            }

            @Test
            fun `check if bishop can capture enemy pieces`() {
                board.getSpotById("b7").piece = Pawn(false)
                board.getSpotById("g6").piece = Pawn(false)
                board.getSpotById("g2").piece = Pawn(false)
                board.getSpotById("d3").piece = Pawn(false)

                val expectedValueList = listOf(
                    board.getSpotById("b7"),
                    board.getSpotById("g6"),
                    board.getSpotById("g2"),
                    board.getSpotById("d3")
                ).toSet()
                val moveList = board.getSpotById("e4").piece.possibleCaptureMoves(board).toSet()
                assertEquals(expectedValueList, moveList)
            }
        }
    }

    @Nested
    inner class Pawn {
        @Nested
        inner class Constructor {
            @Test
            fun `check if the character of white pawn is 'P'`() {
                val pawnP = Pawn(true)
                assertEquals('P', pawnP.char)
            }

            @Test
            fun `check if the character of black pawn is 'p'`() {
                val pawnP = Pawn(false)
                assertEquals('p', pawnP.char)
            }
        }

        @Nested
        inner class PossibleMoves {
            @Test
            fun `check if pawn can advance 2 steps forward from starting position`() {
                val moveList = board.getSpotById("a2").piece.possibleMoves(board)
                val expectedMoveList = listOf(board.getSpotById("a3"), board.getSpotById("a4"))
                assertEquals(expectedMoveList, moveList)

                val moveList2 = board.getSpotById("b2").piece.possibleMoves(board)
                val expectedMoveList2 = listOf(board.getSpotById("b3"), board.getSpotById("b4"))
                assertEquals(expectedMoveList2, moveList2)
            }

            @Test
            fun `check if pawn can advance 1 step when blocked from the 2nd square`() {
                board.getSpotById("c4").piece = Rook(true)
                val moveList = board.getSpotById("c2").piece.possibleMoves(board)
                val expectedMoveList = listOf(board.getSpotById("c3"))
                assertEquals(expectedMoveList, moveList)

                board.getSpotById("d4").piece = Rook(true)
                val moveList2 = board.getSpotById("d2").piece.possibleMoves(board)
                val expectedMoveList2 = listOf(board.getSpotById("d3"))
                assertEquals(expectedMoveList2, moveList2)
            }

            @Test
            fun `check if pawn can not advance when blocked from front`() {
                board.getSpotById("c3").piece = Rook(true)
                val moveList = board.getSpotById("c2").piece.possibleMoves(board)
                val expectedMoveList = emptyList<Spot>()
                assertEquals(expectedMoveList, moveList)

                board.getSpotById("d3").piece = Rook(true)
                val moveList2 = board.getSpotById("d2").piece.possibleMoves(board)
                val expectedMoveList2 = emptyList<Spot>()
                assertEquals(expectedMoveList2, moveList2)
            }

            @Test
            fun `check if pawn can advance only 1 square from every other spots than the starting position`() {
                board.getSpotById("a3").piece = Pawn(true)
                val moveList1 = board.getSpotById("a3").piece.possibleMoves(board)  // [a3a4]
                val expectedMoveList1 = listOf(board.getSpotById("a4"))
                assertEquals(expectedMoveList1, moveList1)

                board.getSpotById("b4").piece = Pawn(true)
                val moveList2 = board.getSpotById("b4").piece.possibleMoves(board)  // [b4b5]
                val expectedMoveList2 = listOf(board.getSpotById("b5"))
                assertEquals(expectedMoveList2, moveList2)

                board.getSpotById("c5").piece = Pawn(true)
                val moveList3 = board.getSpotById("c5").piece.possibleMoves(board)  // [c5c6]
                val expectedMoveList3 = listOf(board.getSpotById("c6"))
                assertEquals(expectedMoveList3, moveList3)

                board.getSpotById("d6").piece = Pawn(true)
                board.getSpotById("d7").piece = Empty(null)
                val moveList4 = board.getSpotById("d6").piece.possibleMoves(board)  // [d6d7]
                val expectedMoveList4 = listOf(board.getSpotById("d7"))
                assertEquals(expectedMoveList4, moveList4)

                board.getSpotById("a7").piece = Pawn(true)
                board.getSpotById("a8").piece = Empty(null)
                val moveList5 = board.getSpotById("a7").piece.possibleMoves(board)  // [a7a8]
                val expectedMoveList5 = listOf(board.getSpotById("a8"))
                assertEquals(expectedMoveList5, moveList5)
            }
        }

        @Nested
        inner class PossibleCaptureMoves {
            init {
                board.getSpotById("b3").piece = Rook(false)
            }

            @Test
            fun `check if left diagonal capture move works`() {
                val captureMoveList = board.getSpotById("c2").piece.possibleCaptureMoves(board)
                val b3List = listOf(board.getSpotById("b3"))
                assertEquals(b3List, captureMoveList)
            }

            @Test
            fun `check if right diagonal capture move works`() {
                val captureMoveList = board.getSpotById("a2").piece.possibleCaptureMoves(board)
                val b3List = listOf(board.getSpotById("b3"))
                assertEquals(b3List, captureMoveList)
            }

            @Test
            fun `check if the En Passant square is capturable`() {
                board.getSpotById("a5").piece = Pawn(true)
                board.getSpotById("b7").piece = Empty(null)
                board.getSpotById("b5").piece = Pawn(false)
                board.enPas = "b6"

                val captureMoveList = board.getSpotById("a5").piece.possibleCaptureMoves(board)
                val expectedList = listOf(board.getSpotById("b6"))
                assertEquals(expectedList, captureMoveList)
            }

            @Test
            fun `check if pawn can't attack forward`() {
                board.getSpotById("e3").piece = Rook(false)
                val captureMoveList = board.getSpotById("e2").piece.possibleCaptureMoves(board)
                val expectedList = emptyList<Spot>()
                assertEquals(expectedList, captureMoveList)
            }
        }
    }

    @Nested
    inner class Empty {
        val board = Board()
        val emptyP = Empty(null)

        @Nested
        inner class Constructor {
            @Test
            fun `check if the empty piece's character is empty`() {
                assertEquals('-', emptyP.char)
            }

            @Test
            fun `check if the possible move list is empty`() {
                assertTrue(emptyP.possibleMoves(board).isEmpty())
                assertTrue(emptyP.possibleCaptureMoves(board).isEmpty())
            }
        }
    }
}