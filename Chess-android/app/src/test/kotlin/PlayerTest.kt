import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import shared_code.Player

class PlayerTest {
    @Nested
    inner class Constructor {
        @Test
        fun `check if the constructor works well`() {
            assertEquals(true, Player(true).isWhite)
            assertEquals(false, Player(false).isWhite)
        }
    }
}