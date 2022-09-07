import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals

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