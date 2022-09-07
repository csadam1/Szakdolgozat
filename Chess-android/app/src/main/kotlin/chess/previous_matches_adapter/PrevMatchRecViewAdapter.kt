package chess.previous_matches_adapter

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.example.chess.R

class PrevMatchRecViewAdapter(context_: Context) : RecyclerView.Adapter<PrevMatchRecViewAdapter.ViewHolder>() {
    private var prevMatches = mutableListOf<PrevMatch>()
    private val context: Context

    init {
        context = context_
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.prev_match_list_item, parent, false)
        val holder = ViewHolder(view)
        return holder
    }

    override fun onBindViewHolder(holder: ViewHolder, @SuppressLint("RecyclerView") position: Int) {
        holder.txtName.text = prevMatches[position].name
        holder.parent.setOnClickListener {
            Toast.makeText(context, prevMatches[position].name + " Selected", Toast.LENGTH_SHORT).show()
        }
    }

    override fun getItemCount(): Int {
        return prevMatches.size
    }

    fun setPrevMatches(prevMatches_: MutableList<PrevMatch>) {
        prevMatches = prevMatches_
        notifyDataSetChanged()
    }

    class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val txtName: TextView
        val parent: RelativeLayout
        init {
            txtName = itemView.findViewById(R.id.txtName)
            parent = itemView.findViewById(R.id.parent)
        }
    }
}

