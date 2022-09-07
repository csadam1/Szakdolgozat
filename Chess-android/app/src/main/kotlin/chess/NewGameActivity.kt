package chess

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.example.chess.R

class NewGameActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_new_game)
    }

    fun btnBackToMain(view: android.view.View) {
        startActivity(Intent(this, MainActivity::class.java))
    }

    fun btnPlayGame(view: android.view.View) {
        startActivity(Intent(this, InOfflineGameActivity::class.java))
    }
}