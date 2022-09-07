import Foundation

class Game {
    let player1: Player
    let player2: Player
    let board: Board
    var moves: [Move]
    var status: GameStatus
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        self.board = Board()
        self.moves = [Move]()
        self.status = GameStatus.ACTIVE
    }
    
    func printBoard() {
        board.toPrint()
    }
    
    func printBoardIDs() {
        board.toPrintIDs()
    }
    
    func getCurrentPlayer() -> Player {
        if board.side == "w" && player1.isWhite  { return player1 }
        if board.side == "b" && !player1.isWhite { return player1 }
        return player2
    }
    
    func isGameOver() -> Bool {
        return (status != GameStatus.ACTIVE)
    }
    
    func isPromotion(fromSpot: Spot) -> Bool {
        if type(of: fromSpot.piece) != type(of: Pawn()) {
            return false
        }
        
        let (rank, _) = board.getPosition(piece: fromSpot.piece)
        let direction = (fromSpot.piece.isWhite!) ? -1 : 1
        if rank+direction==0 || rank+direction==7 {
            return true
        }
        
        return false
    }
    
    func updateStatus() {
        let isWhite = board.side == "w"
        let spotsOfPlayer = board.allSpotsOfPlayer(isWhite: isWhite)
        var allPossibleMoves = [[Spot]]()
        
        for spot in spotsOfPlayer {
            allPossibleMoves.append(board.filterNotSafeMoves(from: spot.id, moveList: spot.piece.possibleMoves(board: board)))
            allPossibleMoves.append(board.filterNotSafeMoves(from: spot.id, moveList: spot.piece.possibleCaptureMoves(board: board)))
        }
        
        let isKingInCheck = board.isKingUnderCheck(enemySpotList: board.allSpotsOfPlayer(isWhite: !isWhite))
        if (allPossibleMoves.flatMap { $0 }.isEmpty && !isKingInCheck) {
            status = GameStatus.DRAW
        }
        if (allPossibleMoves.flatMap { $0 }.isEmpty && isKingInCheck) {
            status = (isWhite) ? GameStatus.BLACK_WIN : GameStatus.WHITE_WIN
        }
    }
    
    func showSelectedMoves() {
        print(board.board.flatMap { $0 }.filter { $0.highlighted }.map { $0.id })
    }
}
