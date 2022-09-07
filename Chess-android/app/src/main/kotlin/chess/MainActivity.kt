package chess

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import com.example.chess.R

class MainActivity : AppCompatActivity(), View.OnClickListener {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.btnNewGame).setOnClickListener(this)
        findViewById<Button>(R.id.btnPrevMatches).setOnClickListener(this)
        findViewById<Button>(R.id.btnLeaderboard).setOnClickListener(this)
        findViewById<Button>(R.id.btnFriends).setOnClickListener(this)

    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnNewGame -> startActivity(Intent(this, NewGameActivity::class.java))
            R.id.btnPrevMatches -> startActivity(Intent(this, PreviousMatchesActivity::class.java))
            R.id.btnLeaderboard -> startActivity(Intent(this, LeaderboardActivity::class.java))
            R.id.btnFriends -> startActivity(Intent(this, FriendsActivity::class.java))
            else -> {}
        }
    }
}
