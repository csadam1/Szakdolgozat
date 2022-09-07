import XCTest
@testable import Chess

class GameTests: XCTestCase {
    var p1: Player!
    var p2: Player!
    var game1: Game!
    
    override func setUp() {
        p1 = Player(isWhite: true)
        p2 = Player(isWhite: false)
        game1 = Game(player1: p1, player2: p2)
    }
    
    /*
        Constructor
     */
    
    func test_if_the_players_are_correctly_set() throws {
        XCTAssertIdentical(p1, game1.player1)
        XCTAssertIdentical(p2, game1.player2)
    }
    
    func test_if_the_move_list_is_empty() throws {
        XCTAssertTrue(game1.moves.isEmpty)
    }

    func test_if_the_status_is_active() throws {
        XCTAssertEqual(GameStatus.ACTIVE, game1.status)
    }
    
    /*
        GetCurrentPlayer
     */
    
    func test_if_the_starting_player_is_white() throws {
        let isWhite = game1.getCurrentPlayer().isWhite
        XCTAssertEqual(true, isWhite)
    }
    
    func test_if_the_player_can_be_set_to_black() throws {
        game1.board.side = "b"
        let isWhite = game1.getCurrentPlayer().isWhite
        XCTAssertEqual(false, isWhite)
    }
    
    /*
        IsGameOver
     */
    
    func test_if_the_game_status_is_active_the_game_is_not_over() throws {
        game1.status = GameStatus.ACTIVE
        XCTAssertFalse(game1.isGameOver())
    }
    
    func test_if_the_game_status_is_not_active_the_game_is_over() throws {
        game1.status = GameStatus.WHITE_WIN
        XCTAssertTrue(game1.isGameOver())
        
        game1.status = GameStatus.BLACK_WIN
        XCTAssertTrue(game1.isGameOver())
        
        game1.status = GameStatus.DRAW
        XCTAssertTrue(game1.isGameOver())
    }
    
    /*
        IsPromotion
     */
    
    func test_if_only_at_the_end_of_the_table_can_a_pawn_be_promoted() throws {
        let a2 = game1.board.board[6][0]
        let promotable1 = game1.isPromotion(fromSpot: a2)
        XCTAssertFalse(promotable1)
        
        let b2 = game1.board.board[6][1]
        let promotable2 = game1.isPromotion(fromSpot: b2)
        XCTAssertFalse(promotable2)
        
        let c2 = game1.board.board[6][2]
        let promotable3 = game1.isPromotion(fromSpot: c2)
        XCTAssertFalse(promotable3)
        
        let d2 = game1.board.board[6][3]
        let promotable4 = game1.isPromotion(fromSpot: d2)
        XCTAssertFalse(promotable4)
        
        let e2 = game1.board.board[6][4]
        let promotable5 = game1.isPromotion(fromSpot: e2)
        XCTAssertFalse(promotable5)
        
        let f2 = game1.board.board[6][5]
        let promotable6 = game1.isPromotion(fromSpot: f2)
        XCTAssertFalse(promotable6)
        
        let g2 = game1.board.board[6][6]
        let promotable7 = game1.isPromotion(fromSpot: g2)
        XCTAssertFalse(promotable7)
        
        let h2 = game1.board.board[6][7]
        let promotable8 = game1.isPromotion(fromSpot: h2)
        XCTAssertFalse(promotable8)
        
        game1.board.board[1][7].piece = Pawn(isWhite: true)
        
        let h7 = game1.board.board[1][7]
        let promotabl9 = game1.isPromotion(fromSpot: h7)
        XCTAssertTrue(promotabl9)
    }
    
    func test_if_other_Pieces_can_not_be_promoted() throws {
        let a1 = game1.board.board[7][0]
        let promotable1 = game1.isPromotion(fromSpot: a1)
        XCTAssertFalse(promotable1)
        
        let b1 = game1.board.board[7][1]
        let promotable2 = game1.isPromotion(fromSpot: b1)
        XCTAssertFalse(promotable2)
        
        let c1 = game1.board.board[7][2]
        let promotable3 = game1.isPromotion(fromSpot: c1)
        XCTAssertFalse(promotable3)
        
        let d1 = game1.board.board[7][3]
        let promotable4 = game1.isPromotion(fromSpot: d1)
        XCTAssertFalse(promotable4)
        
        let e1 = game1.board.board[7][4]
        let promotable5 = game1.isPromotion(fromSpot: e1)
        XCTAssertFalse(promotable5)
    }
    
    func test_if_the_black_pawn_can_step_back_to_be_promoted() throws {
        let a7 = game1.board.board[1][0]
        let promotable1 = game1.isPromotion(fromSpot: a7)
        XCTAssertFalse(promotable1)
        
        let b7 = game1.board.board[1][1]
        let promotable2 = game1.isPromotion(fromSpot: b7)
        XCTAssertFalse(promotable2)
        
        let c7 = game1.board.board[1][2]
        let promotable3 = game1.isPromotion(fromSpot: c7)
        XCTAssertFalse(promotable3)
    }
    
    func test_if_a_big_piece_can_not_be_promoted() throws {
        game1.board.board[1][7].piece = Rook(isWhite: true)
        let h7_1 = game1.board.board[1][7]
        let promotable1 = game1.isPromotion(fromSpot: h7_1)
        XCTAssertFalse(promotable1)
        
        game1.board.board[1][7].piece = Bishop(isWhite: true)
        let h7_2 = game1.board.board[1][7]
        let promotable2 = game1.isPromotion(fromSpot: h7_2)
        XCTAssertFalse(promotable2)
        
        game1.board.board[1][7].piece = Knight(isWhite: true)
        let h7_3 = game1.board.board[1][7]
        let promotable3 = game1.isPromotion(fromSpot: h7_3)
        XCTAssertFalse(promotable3)
        
        game1.board.board[1][7].piece = King(isWhite: true)
        let h7_4 = game1.board.board[1][7]
        let promotable4 = game1.isPromotion(fromSpot: h7_4)
        XCTAssertFalse(promotable4)
        
        game1.board.board[1][7].piece = Queen(isWhite: true)
        let h7_5 = game1.board.board[1][7]
        let promotable5 = game1.isPromotion(fromSpot: h7_5)
        XCTAssertFalse(promotable5)
    }
    
    /*
        UpdateStatus
     */
    
    func initUpdateStatus() {
        game1.board.castPerm = "-"
        
        for i in (0...7) {
            for spot in game1.board.board[i] {
                spot.piece = Empty()
            }
        }
        
        game1.board.board[0][7].piece = King(isWhite: false)
        game1.board.board[7][0].piece = King(isWhite: true)
    }
    
    func test_if_the_status_will_be_draw_at_stalemate() throws {
        initUpdateStatus()
        
        game1.board.board[6][7].piece = Rook(isWhite: false)
        game1.board.board[0][1].piece = Rook(isWhite: false)
        
        game1.updateStatus()
        XCTAssertEqual(GameStatus.DRAW, game1.status)
    }
    
    func test_if_the_status_will_be_Black_Win_at_black_mate() throws {
        initUpdateStatus()
        
        game1.board.board[6][7].piece = Rook(isWhite: false)
        game1.board.board[0][1].piece = Rook(isWhite: false)
        game1.board.board[7][1].piece = Queen(isWhite: false)
        
        game1.updateStatus()
        XCTAssertEqual(GameStatus.BLACK_WIN, game1.status)
    }
    
    func test_if_the_status_will_be_White_Win_at_white_mate() throws {
        initUpdateStatus()
        
        game1.board.side = "b"
        
        game1.board.board[7][6].piece = Rook(isWhite: true)
        game1.board.board[1][0].piece = Rook(isWhite: true)
        game1.board.board[1][7].piece = Queen(isWhite: true)
        
        game1.updateStatus()
        XCTAssertEqual(GameStatus.WHITE_WIN, game1.status)
    }
}
