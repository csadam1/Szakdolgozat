package chess.board_adapter

import shared_code.Game
import shared_code.GameStatus
import shared_code.Move
import shared_code.Player
import shared_code.Spot
import android.content.Context
import android.view.*
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.example.chess.R

class OfflineBoardAdapter(context_: Context, game_: Game, promoButtonList_: List<View>, gameOverIds: Pair<View, TextView>, proposals_: List<View>, currentPlayer_: TextView) : RecyclerView.Adapter<OfflineBoardAdapter.ViewHolder>() {
    private var spots = mutableListOf<Spot>()

    private val promoButtonList: List<View>
    private val context: Context
    private val game: Game
    private val gameOverScreen: View
    private var gameOverText: TextView
    private val proposals: List<View>
    var allMoves = mutableListOf<List<Spot>>()
    var fromSpot: Spot? = null
    var toSpot: Spot? = null
    var showPanel: Boolean = false
    var currentPlayer: TextView

    init {
        context = context_
        game = game_
        promoButtonList = promoButtonList_
        gameOverScreen = gameOverIds.first
        gameOverText = gameOverIds.second
        proposals = proposals_
        currentPlayer = currentPlayer_
    }

    class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val spot: RelativeLayout
        val child: ImageView
        init {
            spot = itemView.findViewById(R.id.spot)
            child = itemView.findViewById(R.id.child)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.spot_item, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.setIsRecyclable(false)
        setLayout(holder, position)
        currentPlayer.text = if (game.getCurrentPlayer().isWhite) "white" else "black"

        promoPanelController()
        proposalController()
        holder.spot.setOnClickListener {
            move(position)
            game.updateStatus()
            if (isGameOver()) announceGameEnd()
            notifyDataSetChanged()
        }

    }

    private fun proposalController() {
        val offerScreen = proposals[1]
        proposals.forEachIndexed { index, view ->
            view.setOnClickListener {
                when (index) {
                    0 -> game.status = proposal(game.getCurrentPlayer(), game, "r")
                    2 -> {
                        game.status = proposal(game.getCurrentPlayer(), game, "y")
                        offerScreen.visibility = View.GONE
                    }
                    3 -> offerScreen.visibility = View.GONE
                }
                if (isGameOver()) announceGameEnd()
                notifyDataSetChanged()
            }
        }
    }

    fun proposal(player: Player, game: Game, input: String): GameStatus {
        if (input == "r" && player.isWhite) game.status = GameStatus.BLACK_WIN
        if (input == "r" && !player.isWhite) game.status = GameStatus.WHITE_WIN

        if (input == "y") {
            game.status = GameStatus.DRAW
        }
        return game.status
    }

    private fun isGameOver(): Boolean {
        return game.status != GameStatus.ACTIVE
    }

    fun announceGameEnd() {
        gameOverScreen.visibility = View.VISIBLE
        if (game.status == GameStatus.DRAW) gameOverText.text = "The game is DRAW!"
        else gameOverText.text = "The winner is the ${ if (game.status== GameStatus.WHITE_WIN) "WHITE" else "BLACK" } player!"
    }

    private fun promoPanelController() {
        if (showPanel) showPromoPanel() else hidePromoPanel()
        promoButtonList.forEachIndexed { index, it ->
            it.setOnClickListener {
                when (index) {
                    0 -> selectSpotToMovePromo(promo = 'q', player = game.getCurrentPlayer(), game = game)
                    1 -> selectSpotToMovePromo(promo = 'r', player = game.getCurrentPlayer(), game = game)
                    2 -> selectSpotToMovePromo(promo = 'b', player = game.getCurrentPlayer(), game = game)
                    3 -> selectSpotToMovePromo(promo = 'n', player = game.getCurrentPlayer(), game = game)
                    else -> { return@setOnClickListener }
                }
                showPanel = false
                notifyDataSetChanged()
            }
        }
    }

    private fun move(position: Int) {
        val player = game.getCurrentPlayer()

        val selectedSpot = spots[position]  // selected spot
        if (player.isWhite == selectedSpot.piece.isWhite) {  // if same color
            selectSpot(selectedSpot)
        } else {
            if (fromSpot != null && game.isPromotion(fromSpot!!))
                selectSpotToMovePromo(spot = selectedSpot)
            else selectSpotToMove(player, selectedSpot)
        }
    }

    private fun showPromoPanel() {
        promoButtonList.last().visibility = View.VISIBLE
    }
    private fun hidePromoPanel() {
        promoButtonList.last().visibility = View.INVISIBLE
    }

    fun selectSpotToMovePromo(spot: Spot? = null, promo: Char? = null, player: Player? = null, game: Game? = null) {
        if (spot != null) {
            if (spot.highlighted) {
                toSpot = spot
                showPanel = true
            }
        }
        if (promo != null) {
            showPanel = false
            val move = Move(player!!, fromSpot!!.id+toSpot!!.id+promo)
            game!!.moves.add(move)  // store the shared_code.move
            game.board.makeMove(move)  // make the shared_code.move

            fromSpot = null  // reset selection
            toSpot = null  // reset selection
            game.board.board.flatten().forEach { it.highlighted = false }  // reset highlights
        }
    }

    fun selectSpotToMove(player: Player, spot: Spot) {
        if (spot.highlighted) {
            toSpot = spot
            val move = Move(player, fromSpot!!.id+toSpot!!.id)
            game.moves.add(move)  // store the shared_code.move
            game.board.makeMove(move)  // make the shared_code.move
        }
        fromSpot = null  // reset selection
        game.board.board.flatten().forEach { it.highlighted = false }  // reset highlights
    }

    fun selectSpot(spot: Spot) {
        game.board.board.flatten().forEach { it.highlighted = false }  // reset highlights
        fromSpot = spot
        toSpot = null

        allMoves = mutableListOf()
        allMoves.add(game.board.filterNotSafeMoves(spot.id, spot.piece.possibleMoves(game.board)))
        allMoves.add(game.board.filterNotSafeMoves(spot.id, spot.piece.possibleCaptureMoves(game.board)))

        allMoves.flatten().forEach { it.highlighted = true }
    }

    private fun setLayout(holder: ViewHolder, position: Int) {
        holder.child.setImageDrawable(null)
        val pieceChar = spots[position].piece.char
        val resId = selectImage(pieceChar)
        if (resId != 0) {
            val drawable = ContextCompat.getDrawable(context, resId)
            holder.child.setImageDrawable(drawable)
        } else {
            holder.child.setImageDrawable(null)
        }

        if (spots[position].highlighted) holder.child.background = ContextCompat.getDrawable(context, R.drawable.highlight)
    }

    private fun selectImage(char: Char): Int {
        return when (char) {
            'P' -> R.drawable.chess_plt60
            'p' -> R.drawable.chess_pdt60
            'B' -> R.drawable.chess_blt60
            'b' -> R.drawable.chess_bdt60
            'N' -> R.drawable.chess_nlt60
            'n' -> R.drawable.chess_ndt60
            'R' -> R.drawable.chess_rlt60
            'r' -> R.drawable.chess_rdt60
            'Q' -> R.drawable.chess_qlt60
            'q' -> R.drawable.chess_qdt60
            'K' -> R.drawable.chess_klt60
            'k' -> R.drawable.chess_kdt60
            else -> 0
        }
    }

    override fun getItemCount(): Int {
        return spots.size
    }

    fun setSpots(spots_: MutableList<Spot>) {
        spots = spots_
        notifyDataSetChanged()
    }
}