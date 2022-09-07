import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import shared_code.*

class GameTest {
    private val p1 = Player(true)
    private val p2 = Player(false)
    private val game1 = Game(p1, p2)

    @Nested
    inner class Constructor {
        @Test
        fun `check if the players are correctly set`() {
            assertEquals(p1, game1.player1)
            assertEquals(p2, game1.player2)
        }

        @Test
        fun `check if the move list is empty`() {
            assertTrue(game1.moves.isEmpty())
        }

        @Test
        fun `check if the status is active`() {
            assertEquals(GameStatus.ACTIVE, game1.status)
        }
    }

    @Nested
    inner class GetCurrentPlayer {
        @Test
        fun `check if the starting player is white`() {
            val isWhite = game1.getCurrentPlayer().isWhite
            assertEquals(true, isWhite)
        }

        @Test
        fun `check if the player can be set to black`() {
            game1.board.side = "b"
            val isWhite = game1.getCurrentPlayer().isWhite
            assertEquals(false, isWhite)
        }
    }

    @Nested
    inner class IsGameOver {
        @Test
        fun `check if the game status is active, the game is not over`() {
            game1.status = GameStatus.ACTIVE
            assertFalse(game1.isGameOver())
        }

        @Test
        fun `check if the game status is not active, the game is over`() {
            game1.status = GameStatus.WHITE_WIN
            assertTrue(game1.isGameOver())

            game1.status = GameStatus.BLACK_WIN
            assertTrue(game1.isGameOver())

            game1.status = GameStatus.DRAW
            assertTrue(game1.isGameOver())
        }
    }

    @Nested
    inner class IsPromotion {
        @Test
        fun `check if only at the end of the table can a pawn be promoted`() {
            val a2 = game1.board.board[6][0]
            val promotable1 = game1.isPromotion(a2)
            assertFalse(promotable1)

            val b2 = game1.board.board[6][1]
            val promotable2 = game1.isPromotion(b2)
            assertFalse(promotable2)

            val c2 = game1.board.board[6][2]
            val promotable3 = game1.isPromotion(c2)
            assertFalse(promotable3)

            val d2 = game1.board.board[6][3]
            val promotable4 = game1.isPromotion(d2)
            assertFalse(promotable4)

            val e2 = game1.board.board[6][4]
            val promotable5 = game1.isPromotion(e2)
            assertFalse(promotable5)

            val f2 = game1.board.board[6][5]
            val promotable6 = game1.isPromotion(f2)
            assertFalse(promotable6)

            val g2 = game1.board.board[6][6]
            val promotable7 = game1.isPromotion(g2)
            assertFalse(promotable7)

            val h2 = game1.board.board[6][7]
            val promotable8 = game1.isPromotion(h2)
            assertFalse(promotable8)

            game1.board.board[1][7].piece = Pawn(true)

            val h7 = game1.board.board[1][7]
            val promotable9 = game1.isPromotion(h7)
            assertTrue(promotable9)
        }

        @Test
        fun `check if other pieces can't be promoted`() {
            val a1 = game1.board.board[7][0]
            val promotable1 = game1.isPromotion(a1)
            assertFalse(promotable1)

            val b1 = game1.board.board[7][1]
            val promotable2 = game1.isPromotion(b1)
            assertFalse(promotable2)

            val c1 = game1.board.board[7][2]
            val promotable3 = game1.isPromotion(c1)
            assertFalse(promotable3)

            val d1 = game1.board.board[7][3]
            val promotable4 = game1.isPromotion(d1)
            assertFalse(promotable4)

            val e1 = game1.board.board[7][4]
            val promotable5 = game1.isPromotion(e1)
            assertFalse(promotable5)
        }

        @Test
        fun `check if the black pawn can step back to be promoted`() {
            val a7 = game1.board.board[1][0]
            val promotable1 = game1.isPromotion(a7)
            assertFalse(promotable1)

            val b7 = game1.board.board[1][1]
            val promotable2 = game1.isPromotion(b7)
            assertFalse(promotable2)

            val c7 = game1.board.board[1][2]
            val promotable3 = game1.isPromotion(c7)
            assertFalse(promotable3)
        }

        @Test
        fun `check if a big piece can't be promoted`() {
            game1.board.board[1][7].piece = Rook(true)
            val h7_1 = game1.board.board[1][7]
            val promotable1 = game1.isPromotion(h7_1)
            assertFalse(promotable1)

            game1.board.board[1][7].piece = Bishop(true)
            val h7_2 = game1.board.board[1][7]
            val promotable2 = game1.isPromotion(h7_2)
            assertFalse(promotable2)

            game1.board.board[1][7].piece = Knight(true)
            val h7_3 = game1.board.board[1][7]
            val promotable3 = game1.isPromotion(h7_3)
            assertFalse(promotable3)

            game1.board.board[1][7].piece = King(true)
            val h7_4 = game1.board.board[1][7]
            val promotable4 = game1.isPromotion(h7_4)
            assertFalse(promotable4)

            game1.board.board[1][7].piece = Queen(true)
            val h7_5 = game1.board.board[1][7]
            val promotable5 = game1.isPromotion(h7_5)
            assertFalse(promotable5)
        }
    }

    @Nested
    inner class UpdateStatus {
        init {
            game1.board.castPerm = "-"

            for (i in 0 until 8) {
                game1.board.board[i].forEach { spot: Spot ->
                    spot.piece = Empty()
                }
            }

            game1.board.board[0][7].piece = King(false)
            game1.board.board[7][0].piece = King(true)
        }

        @Test
        fun `check if the status will be 'Draw' at stalemate`() {
            game1.board.board[6][7].piece = Rook(false)
            game1.board.board[0][1].piece = Rook(false)

            game1.updateStatus()
            assertEquals(GameStatus.DRAW, game1.status)
        }

        @Test
        fun `check if the status will be 'Black_Win' at black mate`() {
            game1.board.board[6][7].piece = Rook(false)
            game1.board.board[0][1].piece = Rook(false)
            game1.board.board[7][1].piece = Queen(false)

            game1.updateStatus()
            assertEquals(GameStatus.BLACK_WIN, game1.status)
        }

        @Test
        fun `check if the status will be 'White_Win' at white mate`() {
            game1.board.side = "b"

            game1.board.board[7][6].piece = Rook(true)
            game1.board.board[1][0].piece = Rook(true)
            game1.board.board[1][7].piece = Queen(true)

            game1.updateStatus()
            assertEquals(GameStatus.WHITE_WIN, game1.status)
        }
    }
}