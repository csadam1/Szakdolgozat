package chess

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.chess.R
import chess.previous_matches_adapter.PrevMatch
import chess.previous_matches_adapter.PrevMatchRecViewAdapter

class PreviousMatchesActivity : AppCompatActivity() {
    lateinit var prevMatchesRecView: RecyclerView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_previous_matches)

        prevMatchesRecView = findViewById(R.id.prevMatches)

        val prevMatches = mutableListOf<PrevMatch>()
        prevMatches.add(PrevMatch("jon.doe.9", "2022.01.01"))
        prevMatches.add(PrevMatch("Aspect", "2022.01.01"))
        prevMatches.add(PrevMatch("Kraken", "2022.01.01"))
        prevMatches.add(PrevMatch("shaquille.oatmeal", "2022.01.01"))
        prevMatches.add(PrevMatch("hanging_with_my_gnomies", "2022.01.01"))
        prevMatches.add(PrevMatch("BadKarma", "2022.01.01"))
        prevMatches.add(PrevMatch("google_was_my_idea", "2022.01.01"))
        prevMatches.add(PrevMatch("shaquille.oatmeal", "2022.01.01"))
        prevMatches.add(PrevMatch("hanging_with_my_gnomies", "2022.01.01"))
        prevMatches.add(PrevMatch("BadKarma", "2022.01.01"))
        prevMatches.add(PrevMatch("google_was_my_idea", "2022.01.01"))
        prevMatches.add(PrevMatch("#Sample_match_002", "2022.01.01"))
        prevMatches.add(PrevMatch("#Sample_match_001", "2022.01.01"))

        val adapter = PrevMatchRecViewAdapter(this)
        adapter.setPrevMatches(prevMatches)

        prevMatchesRecView.adapter = adapter
        prevMatchesRecView.layoutManager = LinearLayoutManager(this)
    }

    fun btnBackToMain(view: View) {
        startActivity(Intent(this, MainActivity::class.java))
    }
}