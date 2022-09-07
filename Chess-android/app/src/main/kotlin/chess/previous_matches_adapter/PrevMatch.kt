package chess.previous_matches_adapter

class PrevMatch(name_: String, date_: String) {
    val name: String
    val date: String
    val imageURL: String

    init {
        name = name_
        date = date_
        imageURL = "123"
    }

    override fun toString(): String {
        return "PrevMatch(name='$name', date='$date', imageURL='$imageURL')"
    }


}