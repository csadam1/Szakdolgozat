import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import shared_code.Move
import shared_code.Player


class MoveTest {
    @Nested
    inner class Constructor {
        private val player1 = Player(true)
        private val uciNotation1 = "e2e4"
        private val uciNotation2 = "d5d8q"
        private val move1 = Move(player1, uciNotation1)
        private val move2 = Move(player1, uciNotation2)

        @Test
        fun `check if the 'from' value is correct`() {
            assertEquals("e2", move1.from)
            assertEquals("d5", move2.from)
        }

        @Test
        fun `check if the 'to' value is correct`() {
            assertEquals("e4", move1.to)
            assertEquals("d8", move2.to)
        }

        @Test
        fun `check if the 'promotion' value is correct`() {
            assertNull(move1.promotion)
            assertEquals("q", move2.promotion)
        }

        @Test
        fun `check if the player is set`() {
            assertEquals(player1, move1.player)
            assertEquals(player1, move2.player)
        }
    }
}