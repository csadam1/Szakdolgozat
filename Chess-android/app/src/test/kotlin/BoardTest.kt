import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import shared_code.*

class BoardTest {
    val board = Board()

    @Nested
    inner class ParseFEN {
        @Test
        fun `check if the side is correctly set`() {
            board.parseFEN(TEST_FEN_01)
            assertEquals("w", board.side)

            board.parseFEN(TEST_FEN_02)
            assertEquals("b", board.side)
        }

        @Test
        fun `check if the castle permission is correctly set`() {
            board.parseFEN(TEST_FEN_03)
            assertEquals("KQkq", board.castPerm)

            board.parseFEN(TEST_FEN_04)
            assertEquals("KQk", board.castPerm)

            board.parseFEN(TEST_FEN_05)
            assertEquals("KQ", board.castPerm)

            board.parseFEN(TEST_FEN_06)
            assertEquals("K", board.castPerm)

            board.parseFEN(TEST_FEN_07)
            assertEquals("-", board.castPerm)
        }

        @Test
        fun `check if En Passant square is correctly set`() {
            board.parseFEN(TEST_FEN_08)
            assertEquals("e3", board.enPas)

            board.parseFEN(TEST_FEN_09)
            assertEquals("a5", board.enPas)

            board.parseFEN(TEST_FEN_10)
            assertEquals("h4", board.enPas)
        }

        @Test
        fun `check if half moves are correctly set`() {
            board.parseFEN(TEST_FEN_11)
            assertEquals(7, board.halfMove)

            board.parseFEN(TEST_FEN_12)
            assertEquals(4, board.halfMove)

            board.parseFEN(TEST_FEN_13)
            assertEquals(2022, board.halfMove)
        }

        @Test
        fun `check if full moves are correctly set`() {
            board.parseFEN(TEST_FEN_14)
            assertEquals(1, board.fullMove)

            board.parseFEN(TEST_FEN_15)
            assertEquals(3, board.fullMove)

            board.parseFEN(TEST_FEN_16)
            assertEquals(12, board.fullMove)
        }

        @Test
        fun `check if the board is correctly set`() {
            val expectedBoard1 = Board()
            clearTable(expectedBoard1)
            expectedBoard1.getSpotById("a8").piece = Knight(false)
            expectedBoard1.getSpotById("d8").piece = Rook(false)
            expectedBoard1.getSpotById("h8").piece = Knight(true)
            expectedBoard1.getSpotById("f7").piece = Knight(false)
            expectedBoard1.getSpotById("a6").piece = Pawn(true)
            expectedBoard1.getSpotById("f6").piece = Pawn(false)
            expectedBoard1.getSpotById("g5").piece = King(false)
            expectedBoard1.getSpotById("b4").piece = Pawn(true)
            expectedBoard1.getSpotById("c4").piece = Queen(true)
            expectedBoard1.getSpotById("d4").piece = Pawn(false)
            expectedBoard1.getSpotById("c3").piece = Pawn(true)
            expectedBoard1.getSpotById("d3").piece = Rook(true)
            expectedBoard1.getSpotById("g3").piece = Pawn(true)
            expectedBoard1.getSpotById("b2").piece = Pawn(true)
            expectedBoard1.getSpotById("d2").piece = King(true)
            expectedBoard1.getSpotById("e2").piece = Bishop(false)
            clearTable(board)
            board.parseFEN(TEST_FEN_17)

            val expectedList1 = expectedBoard1.board.flatten().map { it.piece.char }
            val actualList1 = board.board.flatten().map { it.piece.char }
            assertEquals(expectedList1, actualList1)


            val expectedBoard2 = Board()
            clearTable(expectedBoard2)
            expectedBoard2.getSpotById("h7").piece = Pawn(false)
            expectedBoard2.getSpotById("e6").piece = Pawn(false)
            expectedBoard2.getSpotById("f6").piece = King(true)
            expectedBoard2.getSpotById("a5").piece = Pawn(false)
            expectedBoard2.getSpotById("b4").piece = Pawn(true)
            expectedBoard2.getSpotById("d4").piece = King(false)
            expectedBoard2.getSpotById("e4").piece = Pawn(false)
            expectedBoard2.getSpotById("g4").piece = Pawn(true)
            expectedBoard2.getSpotById("h4").piece = Pawn(true)
            expectedBoard2.getSpotById("e3").piece = Bishop(false)
            expectedBoard2.getSpotById("b2").piece = Queen(false)
            expectedBoard2.getSpotById("d2").piece = Knight(true)
            expectedBoard2.getSpotById("f2").piece = Knight(true)
            expectedBoard2.getSpotById("g2").piece = Queen(true)
            expectedBoard2.getSpotById("a1").piece = Bishop(true)
            expectedBoard2.getSpotById("e1").piece = Knight(false)
            clearTable(board)
            board.parseFEN(TEST_FEN_18)

            val expectedList2 = expectedBoard2.board.flatten().map { it.piece.char }
            val actualList2 = board.board.flatten().map { it.piece.char }
            assertEquals(expectedList2, actualList2)
        }
    }

    @Nested
    inner class ReplaceRook {
        init {
            clearTable(board)
        }
        @Test
        fun `check if replacing rook for castling works on white queen side`() {
            val player = Player(true)
            board.parseFEN(TEST_FEN_19)
            val move = Move(player, "e1c1")
            board.replaceRook(move)

            assertEquals(Empty::class, board.getSpotById("a1").piece::class)
            assertEquals(Rook::class, board.getSpotById("d1").piece::class)
        }

        @Test
        fun `check if replacing rook for castling works on white king side`() {
            val player = Player(true)
            board.parseFEN(TEST_FEN_20)
            val move = Move(player, "e1g1")
            board.replaceRook(move)

            assertEquals(Empty::class, board.getSpotById("h1").piece::class)
            assertEquals(Rook::class, board.getSpotById("f1").piece::class)
        }

        @Test
        fun `check if replacing rook for castling works on black queen side`() {
            val player = Player(false)
            board.parseFEN(TEST_FEN_21)
            val move = Move(player, "e8c8")
            board.replaceRook(move)

            assertEquals(Empty::class, board.getSpotById("a8").piece::class)
            assertEquals(Rook::class, board.getSpotById("d8").piece::class)
        }

        @Test
        fun `check if replacing rook for castling works on black king side`() {
            val player = Player(false)
            board.parseFEN(TEST_FEN_22)
            val move = Move(player, "e8g8")
            board.replaceRook(move)

            assertEquals(Empty::class, board.getSpotById("h8").piece::class)
            assertEquals(Rook::class, board.getSpotById("f8").piece::class)
        }
    }

    @Nested
    inner class IsCastlingMove {
        @Test
        fun `check if the algorithm recognizes white queen side castling`() {
            val player = Player(true)
            board.parseFEN(TEST_FEN_19)
            val move = Move(player, "e1c1")
            board.replaceRook(move)

            assertTrue(board.isCastlingMove(move))
        }

        @Test
        fun `check if the algorithm recognizes white king side castling`() {
            val player = Player(true)
            board.parseFEN(TEST_FEN_20)
            val move = Move(player, "e1g1")
            board.replaceRook(move)

            assertTrue(board.isCastlingMove(move))
        }

        @Test
        fun `check if the algorithm recognizes black queen side castling`() {
            val player = Player(false)
            board.parseFEN(TEST_FEN_21)
            val move = Move(player, "e8c8")
            board.replaceRook(move)

            assertTrue(board.isCastlingMove(move))
        }

        @Test
        fun `check if the algorithm recognizes black king side castling`() {
            val player = Player(false)
            board.parseFEN(TEST_FEN_22)
            val move = Move(player, "e8g8")
            board.replaceRook(move)

            assertTrue(board.isCastlingMove(move))
        }
    }

    @Nested
    inner class IsPromotionMove {
        val player = Player(true)

        @Test
        fun `check if return value true when a promotion move is passed`() {
            val promoMove = Move(player, "e2e4q")
            assertTrue(board.isPromotionMove(promoMove))
        }

        @Test
        fun `check if return value false when not a promotion move is passed`() {
            val nonPromoMove = Move(player, "e2e4")
            assertFalse(board.isPromotionMove(nonPromoMove))
        }
    }

    @Nested
    inner class PromotePawn {
        init {
            clearTable(board)
            board.getSpotById("e2").piece = Pawn(true)
            board.getSpotById("e7").piece = Pawn(false)
        }

        @Test
        fun `check if white pawn gets promoted to queen`() {
            board.side = "w"
            board.promotePawn(board.getSpotById("e2"), "q")
            assertEquals('Q', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if white pawn gets promoted to rook`() {
            board.side = "w"
            board.promotePawn(board.getSpotById("e2"), "r")
            assertEquals('R', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if white pawn gets promoted to knight`() {
            board.side = "w"
            board.promotePawn(board.getSpotById("e2"), "n")
            assertEquals('N', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if white pawn gets promoted to bishop`() {
            board.side = "w"
            board.promotePawn(board.getSpotById("e2"), "b")
            assertEquals('B', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if black pawn gets promoted to queen`() {
            board.side = "b"
            board.promotePawn(board.getSpotById("e2"), "q")
            assertEquals('q', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if black pawn gets promoted to rook`() {
            board.side = "b"
            board.promotePawn(board.getSpotById("e2"), "r")
            assertEquals('r', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if black pawn gets promoted to knight`() {
            board.side = "b"
            board.promotePawn(board.getSpotById("e2"), "n")
            assertEquals('n', board.getSpotById("e2").piece.char)
        }

        @Test
        fun `check if black pawn gets promoted to bishop`() {
            board.side = "b"
            board.promotePawn(board.getSpotById("e2"), "b")
            assertEquals('b', board.getSpotById("e2").piece.char)
        }
    }

    @Nested
    inner class IsEnPasMove {
        init {
            clearTable(board)
            board.getSpotById("e5").piece = Pawn(true)
            board.getSpotById("d5").piece = Pawn(false)
            board.enPas = "d6"
        }

        @Test
        fun `check if En Passant capture move is accepted`() {
            val isAccepted = board.isEnPasMove("d6", board.getSpotById("e5").piece)
            assertTrue(isAccepted)
        }

        @Test
        fun `check if En Passant capture move is not accepted when it's not En Passant square`() {
            board.enPas = "a8"
            val isAccepted = board.isEnPasMove("d6", board.getSpotById("e5").piece)
            assertFalse(isAccepted)
        }

        @Test
        fun `check if En Passant capture move is not accepted when moving with pieces other than pawn`() {
            board.getSpotById("e5").piece = Rook(true)
            val isAccepted = board.isEnPasMove("d6", board.getSpotById("e5").piece)
            assertFalse(isAccepted)
        }
    }

    @Nested
    inner class CaptureEnPas {
        val player = Player(true)

        init {
            clearTable(board)
            board.getSpotById("e5").piece = Pawn(true)
            board.getSpotById("d5").piece = Pawn(false)
            board.enPas = "d6"
        }

        @Test
        fun `check if after executing En Passant capture move the enemy's piece disappears`() {
            val move = Move(player, "e5d6")
            board.captureEnPas(move)
            assertEquals(Empty::class, board.getSpotById("d5").piece::class)
        }
    }

    @Nested
    inner class UpdateFullMove {
        init {
            board.fullMove = 10
        }

        @Test
        fun `check if counter increases by 1 when black moved`() {
            board.side = "w"
            assertEquals(11, board.updateFullMove())
        }

        @Test
        fun `check if counter does not increases when white moved`() {
            board.side = "b"
            assertEquals(10, board.updateFullMove())
        }
    }

    @Nested
    inner class UpdateHalfMove {
        init {
            clearTable(board)
            board.halfMove = 10
            board.getSpotById("e2").piece = Pawn(true)
            board.getSpotById("a1").piece = Rook(true)
            board.getSpotById("a8").piece = Rook(false)
        }

        @Test
        fun `check if counter increases by 1 when move was not by pawn and was not a capture move`() {
            val updatedHalfMove = board.updateHalfMove(board.getSpotById("a1").piece, false)
            assertEquals(11, updatedHalfMove)
        }

        @Test
        fun `check if counter resets to 0 when it was a capture move`() {
            val updatedHalfMove = board.updateHalfMove(board.getSpotById("a1").piece, true)
            assertEquals(0, updatedHalfMove)
        }

        @Test
        fun `check if counter resets to 0 when pawn moved`() {
            val updatedHalfMove = board.updateHalfMove(board.getSpotById("e2").piece, false)
            assertEquals(0, updatedHalfMove)
        }
    }

    @Nested
    inner class UpdateCastPerm {
        val expectedCastPerm = "KQkq"

        init {
            clearTable(board)
            board.getSpotById("a1").piece = Rook(true)
            board.getSpotById("h1").piece = Rook(true)
            board.getSpotById("e1").piece = King(true)

            board.getSpotById("a8").piece = Rook(false)
            board.getSpotById("h8").piece = Rook(false)
            board.getSpotById("e8").piece = King(false)
        }

        @Test
        fun `check if 4 castle permissions are enabled when met with criteria`() {
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals(expectedCastPerm, newCastlePerm)
        }

        @Test
        fun `check if white queen side castle permission is disabled when rook moved away`() {
            board.getSpotById("a1").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("Kkq", newCastlePerm)
        }

        @Test
        fun `check if white king side castle permission is disabled when rook moved away`() {
            board.getSpotById("h1").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("Qkq", newCastlePerm)
        }

        @Test
        fun `check if black queen side castle permission is disabled when when rook moved away`() {
            board.getSpotById("a8").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("KQk", newCastlePerm)
        }

        @Test
        fun `check if black king side castle permission is disabled when rook moved away`() {
            board.getSpotById("h8").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("KQq", newCastlePerm)
        }

        @Test
        fun `check if white castling permission is disabled when king moved away`() {
            board.getSpotById("e1").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("kq", newCastlePerm)
        }

        @Test
        fun `check if black castling permission is disabled when king moved away`() {
            board.getSpotById("e8").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("KQ", newCastlePerm)
        }

        @Test
        fun `check if it returns no castling permission when there is no castling permission available`() {
            board.getSpotById("e1").piece = Empty()
            board.getSpotById("e8").piece = Empty()
            val newCastlePerm = board.updateCastPerm(expectedCastPerm)
            assertEquals("-", newCastlePerm)
        }
    }

    @Nested
    inner class UpdateEnPas {
        val wPlayer = Player(true)
        val bPlayer = Player(false)

        @Test
        fun `check if white player moved with pieces other than pawn there is no En Passant square`() {
            val move = Move(wPlayer, "b1a3")
            assertEquals("-", board.updateEnPas(board.getSpotById("b1").piece, move))
        }

        @Test
        fun `check if white player advances with pawn only 1 square there is no En Passant square`() {
            val move1 = Move(wPlayer, "a2a3")
            assertEquals("-", board.updateEnPas(board.getSpotById("a2").piece, move1))
            val move2 = Move(wPlayer, "b2b3")
            assertEquals("-", board.updateEnPas(board.getSpotById("b2").piece, move2))
            val move3 = Move(wPlayer, "c2c3")
            assertEquals("-", board.updateEnPas(board.getSpotById("c2").piece, move3))
            val move4 = Move(wPlayer, "d2d3")
            assertEquals("-", board.updateEnPas(board.getSpotById("d2").piece, move4))
            val move5 = Move(wPlayer, "e2e3")
            assertEquals("-", board.updateEnPas(board.getSpotById("e2").piece, move5))
            val move6 = Move(wPlayer, "f2f3")
            assertEquals("-", board.updateEnPas(board.getSpotById("f2").piece, move6))
            val move7 = Move(wPlayer, "g2g3")
            assertEquals("-", board.updateEnPas(board.getSpotById("g2").piece, move7))
            val move8 = Move(wPlayer, "h2h3")
            assertEquals("-", board.updateEnPas(board.getSpotById("h2").piece, move8))
        }

        @Test
        fun `check if white player advances with pawn 2 squares there is En Passant square`() {
            val move1 = Move(wPlayer, "a2a4")
            assertEquals("a3", board.updateEnPas(board.getSpotById("a2").piece, move1))
            val move2 = Move(wPlayer, "b2b4")
            assertEquals("b3", board.updateEnPas(board.getSpotById("b2").piece, move2))
            val move3 = Move(wPlayer, "c2c4")
            assertEquals("c3", board.updateEnPas(board.getSpotById("c2").piece, move3))
            val move4 = Move(wPlayer, "d2d4")
            assertEquals("d3", board.updateEnPas(board.getSpotById("d2").piece, move4))
            val move5 = Move(wPlayer, "e2e4")
            assertEquals("e3", board.updateEnPas(board.getSpotById("e2").piece, move5))
            val move6 = Move(wPlayer, "f2f4")
            assertEquals("f3", board.updateEnPas(board.getSpotById("f2").piece, move6))
            val move7 = Move(wPlayer, "g2g4")
            assertEquals("g3", board.updateEnPas(board.getSpotById("g2").piece, move7))
            val move8 = Move(wPlayer, "h2h4")
            assertEquals("h3", board.updateEnPas(board.getSpotById("h2").piece, move8))
        }

        @Test
        fun `check if black player moved with pieces other than pawn there is no En Passant square`() {
            val move = Move(bPlayer, "b8a6")
            assertEquals("-", board.updateEnPas(board.getSpotById("b8").piece, move))
        }

        @Test
        fun `check if black player advances with pawn only 1 square there is no En Passant square`() {
            val move1 = Move(bPlayer, "a7a6")
            assertEquals("-", board.updateEnPas(board.getSpotById("a7").piece, move1))
            val move2 = Move(bPlayer, "b7b6")
            assertEquals("-", board.updateEnPas(board.getSpotById("b7").piece, move2))
            val move3 = Move(bPlayer, "c7c6")
            assertEquals("-", board.updateEnPas(board.getSpotById("c7").piece, move3))
            val move4 = Move(bPlayer, "d7d6")
            assertEquals("-", board.updateEnPas(board.getSpotById("d7").piece, move4))
            val move5 = Move(bPlayer, "e7e6")
            assertEquals("-", board.updateEnPas(board.getSpotById("e7").piece, move5))
            val move6 = Move(bPlayer, "f7f6")
            assertEquals("-", board.updateEnPas(board.getSpotById("f7").piece, move6))
            val move7 = Move(bPlayer, "g7g6")
            assertEquals("-", board.updateEnPas(board.getSpotById("g7").piece, move7))
            val move8 = Move(bPlayer, "h7h6")
            assertEquals("-", board.updateEnPas(board.getSpotById("h7").piece, move8))
        }

        @Test
        fun `check if black player advances with pawn 2 squares there is En Passant square`() {
            val move1 = Move(bPlayer, "a7a5")
            assertEquals("a6", board.updateEnPas(board.getSpotById("a7").piece, move1))
            val move2 = Move(bPlayer, "b7b5")
            assertEquals("b6", board.updateEnPas(board.getSpotById("b7").piece, move2))
            val move3 = Move(bPlayer, "c7c5")
            assertEquals("c6", board.updateEnPas(board.getSpotById("c7").piece, move3))
            val move4 = Move(bPlayer, "d7d5")
            assertEquals("d6", board.updateEnPas(board.getSpotById("d7").piece, move4))
            val move5 = Move(bPlayer, "e7e5")
            assertEquals("e6", board.updateEnPas(board.getSpotById("e7").piece, move5))
            val move6 = Move(bPlayer, "f7f5")
            assertEquals("f6", board.updateEnPas(board.getSpotById("f7").piece, move6))
            val move7 = Move(bPlayer, "g7g5")
            assertEquals("g6", board.updateEnPas(board.getSpotById("g7").piece, move7))
            val move8 = Move(bPlayer, "h7h5")
            assertEquals("h6", board.updateEnPas(board.getSpotById("h7").piece, move8))
        }
    }

    @Nested
    inner class GetSpotById {
        @Test
        fun `check if function returns the correct spots`() {
            listOf(
                "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8",
                "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
                "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6",
                "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5",
                "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4",
                "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3",
                "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2",
                "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"
            ).forEachIndexed { index, id ->
                assertEquals(board.board[index/8][index%8], board.getSpotById(id))
            }
        }
    }

    @Nested
    inner class GetPosition {
        @Test
        fun `check if function returns the correct positions`() {
            board.board.forEachIndexed { i, row ->
                row.forEachIndexed { j, spot ->
                    assertEquals(Pair(i, j), board.getPosition(spot.piece))
                }
            }
        }
    }

    @Nested
    inner class FilterNotSafeMoves {
        init {
            clearTable(board)
            board.getSpotById("e1").piece = King(true)
            board.getSpotById("e8").piece = King(false)
        }

        @Test
        fun `check if function returns the moves where the King will be safe`() {
            board.getSpotById("e7").piece = Rook(false)
            val wKSpot = board.getSpotById("e1")
            val safePlaceForKing = listOf(
                board.getSpotById("d1"), board.getSpotById("d2"),
                board.getSpotById("f1"), board.getSpotById("f2")
            ).toSet()
            val actualSafePlace = board.filterNotSafeMoves("e1", wKSpot.piece.possibleMoves(board)).toSet()
            assertEquals(safePlaceForKing, actualSafePlace)
        }
    }

    @Nested
    inner class IsKingUnderCheck {
        init {
            clearTable(board)
            board.getSpotById("e1").piece = King(true)
            board.getSpotById("e8").piece = King(false)
        }

        @Test
        fun `check if king is not in check works`() {
            assertFalse(board.isKingUnderCheck(board.allSpotsOfPlayer(false)))
            assertFalse(board.isKingUnderCheck(board.allSpotsOfPlayer(true)))
        }

        @Test
        fun `check if king is in check works`() {
            board.getSpotById("e7").piece = Rook(false)
            assertTrue(board.isKingUnderCheck(board.allSpotsOfPlayer(false)))
            board.getSpotById("e7").piece = Empty()
            board.getSpotById("e2").piece = Rook(true)
            assertTrue(board.isKingUnderCheck(board.allSpotsOfPlayer(true)))
        }
    }

    @Nested
    inner class AllSpotsOfPlayer {
        @Test
        fun `check if it selects all the spots where the white player has a piece`() {
            val wPsSpots = listOf(
                board.board[7][0], board.board[7][1], board.board[7][2], board.board[7][3], board.board[7][4], board.board[7][5], board.board[7][6], board.board[7][7],
                board.board[6][0], board.board[6][1], board.board[6][2], board.board[6][3], board.board[6][4], board.board[6][5], board.board[6][6], board.board[6][7]
            ).toSet()
            assertEquals(wPsSpots, board.allSpotsOfPlayer(true).toSet())
        }

        @Test
        fun `check if it selects all the spots where the black player has a piece`() {
            val bPsSpots = listOf(
                board.board[0][0], board.board[0][1], board.board[0][2], board.board[0][3], board.board[0][4], board.board[0][5], board.board[0][6], board.board[0][7],
                board.board[1][0], board.board[1][1], board.board[1][2], board.board[1][3], board.board[1][4], board.board[1][5], board.board[1][6], board.board[1][7]
            ).toSet()
            assertEquals(bPsSpots, board.allSpotsOfPlayer(false).toSet())
        }
    }

    private fun clearTable(b: Board) {
        b.board.forEach { row ->
            row.forEach { spot ->
                spot.piece = Empty(null)
            }
        }
    }
}
