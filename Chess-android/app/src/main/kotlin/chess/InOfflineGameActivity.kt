package chess

import shared_code.Board
import shared_code.Game
import shared_code.Player
import shared_code.Spot
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.chess.R
import chess.board_adapter.OfflineBoardAdapter

class InOfflineGameActivity : AppCompatActivity() {
    lateinit var spotsRecView: RecyclerView
    lateinit var adapter: OfflineBoardAdapter

    lateinit var promoButtons: List<View>
    lateinit var gameOverIds: Pair<View, TextView>
    lateinit var proposals: List<View>
    lateinit var offerScreen: View
    lateinit var currentPlayerI: TextView
    private lateinit var game: Game

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_in_offline_game)

        currentPlayerI = findViewById(R.id.currentPlayerIndicator)
        offerScreen = findViewById(R.id.OfferScreen)
        promoButtons = listOf(findViewById(R.id.btnQueenPromo), findViewById(R.id.btnRookPromo), findViewById(
            R.id.btnBishopPromo
        ), findViewById(R.id.btnKnightPromo), findViewById(R.id.PromoPanel))
        gameOverIds = Pair(findViewById(R.id.gameOverScreen), findViewById(R.id.gameOverText))
        proposals = listOf(findViewById(R.id.btnResign), offerScreen, findViewById(R.id.btnYes), findViewById(
            R.id.btnNo
        ))
        game = initGame()

        spotsRecView = findViewById(R.id.spotsRecView)

        adapter = OfflineBoardAdapter(this, game, promoButtons, gameOverIds, proposals, currentPlayerI)
        printBoard(game.board)
    }

    private fun initGame(): Game {
        val p1 = Player(true)
        val p2 = Player(false)
        return Game(p1, p2)
    }

    private fun printBoard(board: Board) {  // shows board every time
        adapter.setSpots(board.board.flatten() as MutableList<Spot>)
        spotsRecView.adapter = adapter
        spotsRecView.layoutManager = GridLayoutManager(this, 8)
    }

    fun btnOffer(view: android.view.View) {
        offerScreen.visibility = View.VISIBLE
    }

    fun btnBackToMain(view: android.view.View) {
        startActivity(Intent(this, MainActivity::class.java))
    }
}