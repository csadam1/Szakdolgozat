import XCTest
@testable import Chess
import CoreLocation

class BoardTests: XCTestCase {

    var board: Board!
    
    override func setUp() {
        board = Board()
    }
    
    /*
        ParseFEN
     */
    
    func test_if_the_side_is_correctly_set() throws {
        board.parseFEN(customStringFEN: TEST_FEN_01)
        XCTAssertEqual("w", board.side)
        
        board.parseFEN(customStringFEN: TEST_FEN_02)
        XCTAssertEqual("b", board.side)
    }
    
    func test_if_the_castle_permission_is_correctly_set() throws {
        board.parseFEN(customStringFEN: TEST_FEN_03)
        XCTAssertEqual("KQkq", board.castPerm)
        
        board.parseFEN(customStringFEN: TEST_FEN_04)
        XCTAssertEqual("KQk", board.castPerm)
        
        board.parseFEN(customStringFEN: TEST_FEN_05)
        XCTAssertEqual("KQ", board.castPerm)
        
        board.parseFEN(customStringFEN: TEST_FEN_06)
        XCTAssertEqual("K", board.castPerm)
        
        board.parseFEN(customStringFEN: TEST_FEN_07)
        XCTAssertEqual("-", board.castPerm)
    }
    
    func test_if_En_Passant_square_is_correctly_set() throws {
        board.parseFEN(customStringFEN: TEST_FEN_08)
        XCTAssertEqual("e3", board.enPas)
        
        board.parseFEN(customStringFEN: TEST_FEN_09)
        XCTAssertEqual("a5", board.enPas)
        
        board.parseFEN(customStringFEN: TEST_FEN_10)
        XCTAssertEqual("h4", board.enPas)
    }
    
    func test_if_half_moves_are_correctly_set() throws {
        board.parseFEN(customStringFEN: TEST_FEN_11)
        XCTAssertEqual(7, board.halfMove)
        
        board.parseFEN(customStringFEN: TEST_FEN_12)
        XCTAssertEqual(4, board.halfMove)
        
        board.parseFEN(customStringFEN: TEST_FEN_13)
        XCTAssertEqual(2022, board.halfMove)
    }
    
    func test_if_full_moves_are_correctly_set() throws {
        board.parseFEN(customStringFEN: TEST_FEN_14)
        XCTAssertEqual(1, board.fullMove)
        
        board.parseFEN(customStringFEN: TEST_FEN_15)
        XCTAssertEqual(3, board.fullMove)
        
        board.parseFEN(customStringFEN: TEST_FEN_16)
        XCTAssertEqual(12, board.fullMove)
    }
    
    func test_if_the_board_is_correct_set() throws {
        let expectedBoard1 = Board()
        clearTable(b: expectedBoard1)
        expectedBoard1.getSpotById(id: "a8").piece = Knight(isWhite: false)
        expectedBoard1.getSpotById(id: "d8").piece = Rook(isWhite: false)
        expectedBoard1.getSpotById(id: "h8").piece = Knight(isWhite: true)
        expectedBoard1.getSpotById(id: "f7").piece = Knight(isWhite: false)
        expectedBoard1.getSpotById(id: "a6").piece = Pawn(isWhite: true)
        expectedBoard1.getSpotById(id: "f6").piece = Pawn(isWhite: false)
        expectedBoard1.getSpotById(id: "g5").piece = King(isWhite: false)
        expectedBoard1.getSpotById(id: "b4").piece = Pawn(isWhite: true)
        expectedBoard1.getSpotById(id: "c4").piece = Queen(isWhite: true)
        expectedBoard1.getSpotById(id: "d4").piece = Pawn(isWhite: false)
        expectedBoard1.getSpotById(id: "c3").piece = Pawn(isWhite: true)
        expectedBoard1.getSpotById(id: "d3").piece = Rook(isWhite: true)
        expectedBoard1.getSpotById(id: "g3").piece = Pawn(isWhite: true)
        expectedBoard1.getSpotById(id: "b2").piece = Pawn(isWhite: true)
        expectedBoard1.getSpotById(id: "d2").piece = King(isWhite: true)
        expectedBoard1.getSpotById(id: "e2").piece = Bishop(isWhite: false)
        clearTable(b: board)
        board.parseFEN(customStringFEN: TEST_FEN_17)
        
        var expectedList1 = [String]()
        for row in expectedBoard1.board {
            for spot in row {
                expectedList1.append(spot.piece.char)
            }
        }
        var actualList1 = [String]()
        for row in expectedBoard1.board {
            for spot in row {
                actualList1.append(spot.piece.char)
            }
        }
        XCTAssertEqual(expectedList1, actualList1)
        
        let expectedBoard2 = Board()
        clearTable(b: expectedBoard2)
        expectedBoard2.getSpotById(id: "h7").piece = Pawn(isWhite: false)
        expectedBoard2.getSpotById(id: "e6").piece = Pawn(isWhite: false)
        expectedBoard2.getSpotById(id: "f6").piece = King(isWhite: true)
        expectedBoard2.getSpotById(id: "a5").piece = Pawn(isWhite: false)
        expectedBoard2.getSpotById(id: "b4").piece = Pawn(isWhite: true)
        expectedBoard2.getSpotById(id: "d4").piece = King(isWhite: false)
        expectedBoard2.getSpotById(id: "e4").piece = Pawn(isWhite: false)
        expectedBoard2.getSpotById(id: "g4").piece = Pawn(isWhite: true)
        expectedBoard2.getSpotById(id: "h4").piece = Pawn(isWhite: true)
        expectedBoard2.getSpotById(id: "e3").piece = Bishop(isWhite: false)
        expectedBoard2.getSpotById(id: "b2").piece = Queen(isWhite: false)
        expectedBoard2.getSpotById(id: "d2").piece = Knight(isWhite: true)
        expectedBoard2.getSpotById(id: "f2").piece = Knight(isWhite: true)
        expectedBoard2.getSpotById(id: "g2").piece = Queen(isWhite: true)
        expectedBoard2.getSpotById(id: "a1").piece = Bishop(isWhite: true)
        expectedBoard2.getSpotById(id: "e1").piece = Knight(isWhite: false)
        clearTable(b: board)
        board.parseFEN(customStringFEN: TEST_FEN_18)

        var expectedList2 = [String]()
        for row in expectedBoard2.board {
            for spot in row {
                expectedList2.append(spot.piece.char)
            }
        }
        var actualList2 = [String]()
        for row in expectedBoard2.board {
            for spot in row {
                actualList2.append(spot.piece.char)
            }
        }
        XCTAssertEqual(expectedList2, actualList2)
    }
    
    /*
        ReplaceRook
     */
    
    func initReplaceRook() {
        clearTable(b: board)
    }
    
    func test_if_replacing_rook_for_castling_works_on_white_queen_side() throws {
        initReplaceRook()
        
        let player = Player(isWhite: true)
        board.parseFEN(customStringFEN: TEST_FEN_19)
        let move = Move(player: player, chessNotation: "e1c1")
        board.replaceRook(move: move)
        
        XCTAssertIdentical(type(of: Empty()), type(of: board.getSpotById(id: "a1").piece))
        XCTAssertIdentical(type(of: Rook()), type(of: board.getSpotById(id: "d1").piece))
    }
    
    func test_if_replacing_rook_for_castling_works_on_white_king_side() throws {
        initReplaceRook()
        
        let player = Player(isWhite: true)
        board.parseFEN(customStringFEN: TEST_FEN_20)
        let move = Move(player: player, chessNotation: "e1g1")
        board.replaceRook(move: move)
        
        XCTAssertIdentical(type(of: Empty()), type(of: board.getSpotById(id: "h1").piece))
        XCTAssertIdentical(type(of: Rook()), type(of: board.getSpotById(id: "f1").piece))
    }
    
    func test_if_replacing_rook_for_castling_works_on_black_queen_side() throws {
        initReplaceRook()
        
        let player = Player(isWhite: false)
        board.parseFEN(customStringFEN: TEST_FEN_21)
        let move = Move(player: player, chessNotation: "e8c8")
        board.replaceRook(move: move)
        
        XCTAssertIdentical(type(of: Empty()), type(of: board.getSpotById(id: "a8").piece))
        XCTAssertIdentical(type(of: Rook()), type(of: board.getSpotById(id: "d8").piece))
    }
    
    func test_if_replacing_rook_for_castling_works_on_black_king_side() throws {
        initReplaceRook()
        
        let player = Player(isWhite: false)
        board.parseFEN(customStringFEN: TEST_FEN_22)
        let move = Move(player: player, chessNotation: "e8g8")
        board.replaceRook(move: move)
        
        XCTAssertIdentical(type(of: Empty()), type(of: board.getSpotById(id: "h8").piece))
        XCTAssertIdentical(type(of: Rook()), type(of: board.getSpotById(id: "f8").piece))
    }
    
    /*
        IsCastlingMove
     */
    
    func test_if_the_algorithm_recognizes_white_queen_side_castling() throws {
        let player = Player(isWhite: true)
        board.parseFEN(customStringFEN: TEST_FEN_19)
        let move = Move(player: player, chessNotation: "e1c1")
        board.replaceRook(move: move)
        
        XCTAssertTrue(board.isCastlingMove(move: move))
    }
    
    func test_if_the_algorithm_recognizes_white_king_side_castling() throws {
        let player = Player(isWhite: true)
        board.parseFEN(customStringFEN: TEST_FEN_20)
        let move = Move(player: player, chessNotation: "e1g1")
        board.replaceRook(move: move)
        
        XCTAssertTrue(board.isCastlingMove(move: move))
    }
    
    func test_if_the_algorithm_recognizes_black_queen_side_castling() throws {
        let player = Player(isWhite: false)
        board.parseFEN(customStringFEN: TEST_FEN_21)
        let move = Move(player: player, chessNotation: "e8c8")
        board.replaceRook(move: move)
        
        XCTAssertTrue(board.isCastlingMove(move: move))
    }
    
    func test_if_the_algorithm_recognizes_black_king_side_castling() throws {
        let player = Player(isWhite: false)
        board.parseFEN(customStringFEN: TEST_FEN_22)
        let move = Move(player: player, chessNotation: "e8g8")
        board.replaceRook(move: move)
        
        XCTAssertTrue(board.isCastlingMove(move: move))
    }
    
    /*
        IsPromotionMove
     */
    
    func test_if_return_value_true_when_a_promotion_move_is_passed() throws {
        let player = Player(isWhite: true)
        let promoMove = Move(player: player, chessNotation: "e2e4q")
        XCTAssertTrue(board.isPromotionMove(move: promoMove))
    }
    
    func test_if_return_value_false_when_not_a_promotion_move_is_passed() throws {
        let player = Player(isWhite: true)
        let promoMove = Move(player: player, chessNotation: "e2e4")
        XCTAssertFalse(board.isPromotionMove(move: promoMove))
    }
    
    /*
        PromotePawn
     */
    
    func initPromotePawn() {
        clearTable(b: board)
        board.getSpotById(id: "e2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "e7").piece = Pawn(isWhite: false)
    }
    
    func test_if_white_pawn_gets_promoted_to_queen() throws {
        initPromotePawn()
        
        board.side = "w"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "q")
        XCTAssertEqual("Q", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_white_pawn_gets_promote_to_rook() throws {
        initPromotePawn()
        
        board.side = "w"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "r")
        XCTAssertEqual("R", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_white_pawn_gets_promote_to_knight() throws {
        initPromotePawn()
        
        board.side = "w"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "n")
        XCTAssertEqual("N", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_white_pawn_gets_promote_to_bishop() throws {
        initPromotePawn()
        
        board.side = "w"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "b")
        XCTAssertEqual("B", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_black_pawn_gets_promote_to_queen() throws {
        initPromotePawn()
        
        board.side = "b"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "q")
        XCTAssertEqual("q", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_black_pawn_gets_promote_to_rook() throws {
        initPromotePawn()
        
        board.side = "b"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "r")
        XCTAssertEqual("r", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_black_pawn_gets_promote_to_knight() throws {
        initPromotePawn()
        
        board.side = "b"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "n")
        XCTAssertEqual("n", board.getSpotById(id: "e2").piece.char)
    }
    
    func test_if_black_pawn_gets_promote_to_bishop() throws {
        initPromotePawn()
        
        board.side = "b"
        board.promotePawn(spot: board.getSpotById(id: "e2"), promotion: "b")
        XCTAssertEqual("b", board.getSpotById(id: "e2").piece.char)
    }
    
    /*
        IsEnPasMove
     */
    
    func initIsEnPasMove() {
        clearTable(b: board)
        board.getSpotById(id: "e5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d5").piece = Pawn(isWhite: false)
        board.enPas = "d6"
    }
    
    func test_if_En_Passant_capture_move_is_accepted() throws {
        initIsEnPasMove()
        
        let isAccepted = board.isEnPasMove(toSquare: "d6", piece: board.getSpotById(id: "e5").piece)
        XCTAssertTrue(isAccepted)
    }
    
    func test_if_En_Passant_capture_move_is_not_accepted_when_it_is_not_En_Passant_square() throws {
        initIsEnPasMove()
        
        board.enPas = "a8"
        let isAccepted = board.isEnPasMove(toSquare: "d6", piece: board.getSpotById(id: "e5").piece)
        XCTAssertFalse(isAccepted)
    }
    
    func test_if_En_Passant_capture_move_is_not_accepted_when_moving_with_pieces_other_than_pawn() throws {
        initIsEnPasMove()
        
        board.getSpotById(id: "e5").piece = Rook(isWhite: true)
        let isAccepted = board.isEnPasMove(toSquare: "d6", piece: board.getSpotById(id: "e5").piece)
        XCTAssertFalse(isAccepted)
    }
    
    /*
        CaptureEnPas
     */
    
    func initCaptureEnPas() {
        clearTable(b: board)
        board.getSpotById(id: "e5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d5").piece = Pawn(isWhite: false)
        board.enPas = "d6"
    }
    
    func test_if_after_executing_En_Passant_capture_move_the_enemys_piece_disappears() throws {
        initCaptureEnPas()
        
        let player = Player(isWhite: true)
        let move = Move(player: player, chessNotation: "e5d6")
        board.captureEnPas(move: move)
        XCTAssertIdentical(type(of: Empty()), type(of: board.getSpotById(id: "d5").piece))
    }
    
    /*
        UpdateFullMove
     */
    
    func initUpdateFullMove() {
        board.fullMove = 10
    }
    
    func test_if_counter_increases_by_1_when_black_moved() throws {
        initUpdateFullMove()
        
        board.side = "w"
        XCTAssertEqual(11, board.updateFullMove())
    }
    
    func test_if_counter_does_not_increases_when_white_moved() throws {
        initUpdateFullMove()
        
        board.side = "b"
        XCTAssertEqual(10, board.updateFullMove())
    }
    
    /*
        UpdateHalfMove
     */
    
    func initUpdateHalfMove() {
        clearTable(b: board)
        board.halfMove = 10
        board.getSpotById(id: "e2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "a1").piece = Rook(isWhite: true)
        board.getSpotById(id: "a8").piece = Rook(isWhite: false)
    }
    
    func test_if_counter_increases_by_1_when_move_was_not_by_pawn_and_was_not_a_capture_move() throws {
        initUpdateHalfMove()
        
        let updateHalfMove = board.updateHalfMove(piece: board.getSpotById(id: "a1").piece, capture: false)
        XCTAssertEqual(11, updateHalfMove)
    }
    
    func test_if_counter_resets_to_0_when_it_was_a_capture_move() throws {
        initUpdateHalfMove()
        
        let updateHalfMove = board.updateHalfMove(piece: board.getSpotById(id: "a1").piece, capture: true)
        XCTAssertEqual(0, updateHalfMove)
    }
    
    func test_if_counter_resets_to_0_when_pawn_moved() throws {
        initUpdateHalfMove()
        
        let updateHalfMove = board.updateHalfMove(piece: board.getSpotById(id: "e2").piece, capture: false)
        XCTAssertEqual(0, updateHalfMove)
    }
    
    /*
        UpdateCastPerm
     */
    
    func initUpdateCastPerm() {
        clearTable(b: board)
        board.getSpotById(id: "a1").piece = Rook(isWhite: true)
        board.getSpotById(id: "h1").piece = Rook(isWhite: true)
        board.getSpotById(id: "e1").piece = King(isWhite: true)
        
        board.getSpotById(id: "a8").piece = Rook(isWhite: false)
        board.getSpotById(id: "h8").piece = Rook(isWhite: false)
        board.getSpotById(id: "e8").piece = King(isWhite: false)
    }
    
    func test_if_4_castle_permissions_are_enabled_when_met_with_criteria() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual(expectedCastPerm, newCastlePerm)
    }
    
    func test_if_white_queen_side_castle_permission_is_disabled_when_rook_moved_away() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "a1").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("Kkq", newCastlePerm)
    }
    
    func test_if_white_king_side_castle_permission_is_disabled_when_rook_moved_way() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "h1").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("Qkq", newCastlePerm)
    }
    
    func test_if_black_queen_side_castle_permission_is_disabled_when_rook_moved_away() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "a8").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("KQk", newCastlePerm)
    }
    
    func test_if_black_king_side_castle_permission_is_disabled_when_rook_moved_way() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "h8").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("KQq", newCastlePerm)
    }
    
    func test_if_white_castling_permission_is_disabled_when_king_moved_away() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "e1").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("kq", newCastlePerm)
    }
    
    func test_if_black_castling_permission_is_disabled_when_king_moved_away() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "e8").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("KQ", newCastlePerm)
    }
    
    func test_if_it_returns_no_castling_permission_when_there_is_no_castling_permission_available() throws {
        let expectedCastPerm = "KQkq"
        initUpdateCastPerm()
        
        board.getSpotById(id: "e1").piece = Empty()
        board.getSpotById(id: "e8").piece = Empty()
        let newCastlePerm = board.updateCastPerm(castPerm: expectedCastPerm)
        XCTAssertEqual("-", newCastlePerm)
    }
    
    /*
        UpdateEnPas
     */
    
    func test_if_white_player_moved_with_pieces_other_than_pawn_there_is_no_En_Passant_square() throws {
        let wPlayer = Player(isWhite: true)
        
        let move = Move(player: wPlayer, chessNotation: "b1a3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "b1").piece, move: move))
    }
    
    func test_if_white_player_advances_with_pawn_only_1_square_there_is_no_En_Passant_square() throws {
        let wPlayer = Player(isWhite: true)
        
        let move1 = Move(player: wPlayer, chessNotation: "a2a3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "a2").piece, move: move1))
        let move2 = Move(player: wPlayer, chessNotation: "b2b3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "b2").piece, move: move2))
        let move3 = Move(player: wPlayer, chessNotation: "c2c3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "c2").piece, move: move3))
        let move4 = Move(player: wPlayer, chessNotation: "d2d3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "d2").piece, move: move4))
        let move5 = Move(player: wPlayer, chessNotation: "e2e3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "e2").piece, move: move5))
        let move6 = Move(player: wPlayer, chessNotation: "f2f3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "f2").piece, move: move6))
        let move7 = Move(player: wPlayer, chessNotation: "g2g3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "g2").piece, move: move7))
        let move8 = Move(player: wPlayer, chessNotation: "h2h3")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "h2").piece, move: move8))
    }
    
    func test_if_white_player_advances_with_pawn_2_squares_there_is_En_Passant_square() throws {
        let wPlayer = Player(isWhite: true)
        
        let move1 = Move(player: wPlayer, chessNotation: "a2a4")
        XCTAssertEqual("a3", board.updateEnPas(piece: board.getSpotById(id: "a2").piece, move: move1))
        let move2 = Move(player: wPlayer, chessNotation: "b2b4")
        XCTAssertEqual("b3", board.updateEnPas(piece: board.getSpotById(id: "b2").piece, move: move2))
        let move3 = Move(player: wPlayer, chessNotation: "c2c4")
        XCTAssertEqual("c3", board.updateEnPas(piece: board.getSpotById(id: "c2").piece, move: move3))
        let move4 = Move(player: wPlayer, chessNotation: "d2d4")
        XCTAssertEqual("d3", board.updateEnPas(piece: board.getSpotById(id: "d2").piece, move: move4))
        let move5 = Move(player: wPlayer, chessNotation: "e2e4")
        XCTAssertEqual("e3", board.updateEnPas(piece: board.getSpotById(id: "e2").piece, move: move5))
        let move6 = Move(player: wPlayer, chessNotation: "f2f4")
        XCTAssertEqual("f3", board.updateEnPas(piece: board.getSpotById(id: "f2").piece, move: move6))
        let move7 = Move(player: wPlayer, chessNotation: "g2g4")
        XCTAssertEqual("g3", board.updateEnPas(piece: board.getSpotById(id: "g2").piece, move: move7))
        let move8 = Move(player: wPlayer, chessNotation: "h2h4")
        XCTAssertEqual("h3", board.updateEnPas(piece: board.getSpotById(id: "h2").piece, move: move8))
    }
    
    func test_if_black_player_moved_with_pieces_other_than_pawn_ther_is_no_En_Passant_square() throws {
        let bPlayer = Player(isWhite: false)
        
        let move = Move(player: bPlayer, chessNotation: "b8b6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "b8").piece, move: move))    }
    
    func test_if_black_player_advances_with_pawn_only_1_square_there_is_no_En_Passant_square() throws {
        let bPlayer = Player(isWhite: false)
        
        let move1 = Move(player: bPlayer, chessNotation: "a7a6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "a7").piece, move: move1))
        let move2 = Move(player: bPlayer, chessNotation: "b7b6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "b7").piece, move: move2))
        let move3 = Move(player: bPlayer, chessNotation: "c7c6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "c7").piece, move: move3))
        let move4 = Move(player: bPlayer, chessNotation: "d7d6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "d7").piece, move: move4))
        let move5 = Move(player: bPlayer, chessNotation: "e7e6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "e7").piece, move: move5))
        let move6 = Move(player: bPlayer, chessNotation: "f7f6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "f7").piece, move: move6))
        let move7 = Move(player: bPlayer, chessNotation: "g7g6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "g7").piece, move: move7))
        let move8 = Move(player: bPlayer, chessNotation: "h7h6")
        XCTAssertEqual("-", board.updateEnPas(piece: board.getSpotById(id: "h7").piece, move: move8))
    }
    
    func test_if_black_player_advances_with_pawn_2_squares_there_is_En_Passant_square() throws {
        let bPlayer = Player(isWhite: false)
        
        let move1 = Move(player: bPlayer, chessNotation: "a7a5")
        XCTAssertEqual("a6", board.updateEnPas(piece: board.getSpotById(id: "a7").piece, move: move1))
        let move2 = Move(player: bPlayer, chessNotation: "b7b5")
        XCTAssertEqual("b6", board.updateEnPas(piece: board.getSpotById(id: "b7").piece, move: move2))
        let move3 = Move(player: bPlayer, chessNotation: "c7c5")
        XCTAssertEqual("c6", board.updateEnPas(piece: board.getSpotById(id: "c7").piece, move: move3))
        let move4 = Move(player: bPlayer, chessNotation: "d7d5")
        XCTAssertEqual("d6", board.updateEnPas(piece: board.getSpotById(id: "d7").piece, move: move4))
        let move5 = Move(player: bPlayer, chessNotation: "e7e5")
        XCTAssertEqual("e6", board.updateEnPas(piece: board.getSpotById(id: "e7").piece, move: move5))
        let move6 = Move(player: bPlayer, chessNotation: "f7f5")
        XCTAssertEqual("f6", board.updateEnPas(piece: board.getSpotById(id: "f7").piece, move: move6))
        let move7 = Move(player: bPlayer, chessNotation: "g7g5")
        XCTAssertEqual("g6", board.updateEnPas(piece: board.getSpotById(id: "g7").piece, move: move7))
        let move8 = Move(player: bPlayer, chessNotation: "h7h5")
        XCTAssertEqual("h6", board.updateEnPas(piece: board.getSpotById(id: "h7").piece, move: move8))
    }
    
    /*
        GetSpotById
     */
    
    func test_if_function_returns_the_correct_spots() throws {
        let spots = [
            "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8",
            "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
            "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6",
            "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5",
            "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4",
            "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3",
            "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2",
            "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"
        ]
        
        for (index, id) in spots.enumerated() {
            XCTAssertEqual(board.board[index/8][index%8].id, board.getSpotById(id: id).id)
        }
    }
    
    /*
        GetPosition
     */
    
    func test_if_function_returns_the_correct_positions() throws {
        for (i, row) in board.board.enumerated() {
            for (j, spot) in row.enumerated() {
                let (k, l) = board.getPosition(piece: spot.piece)
                XCTAssertEqual(k, i)
                XCTAssertEqual(l, j)
            }
        }
    }
    
    /*
        FilterNotSafeMoves
     */
    
    func initFilterNotSafeMoves() {
        clearTable(b: board)
        board.getSpotById(id: "e1").piece = King(isWhite: true)
        board.getSpotById(id: "e8").piece = King(isWhite: false)
    }
    
    func test_if_function_returns_the_moves_where_the_King_will_be_safe() throws {
        initFilterNotSafeMoves()
        
        board.getSpotById(id: "e7").piece = Rook(isWhite: false)
        let wKSpot = board.getSpotById(id: "e1")
        let safePlaceForKing = [board.getSpotById(id: "d1"), board.getSpotById(id: "d2"), board.getSpotById(id: "f1"), board.getSpotById(id: "f2")]
        let actualSafePlace = board.filterNotSafeMoves(from: "e1", moveList: wKSpot.piece.possibleMoves(board: board))
        
        for item in safePlaceForKing {
            XCTAssertTrue(actualSafePlace.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        IsKingUnderCheck
     */
    
    func initIsKingUnderCheck() {
        clearTable(b: board)
        board.getSpotById(id: "e1").piece = King(isWhite: true)
        board.getSpotById(id: "e8").piece = King(isWhite: false)
    }
    
    func test_if_king_is_not_in_check_works() throws {
        initIsKingUnderCheck()
        
        XCTAssertFalse(board.isKingUnderCheck(enemySpotList: board.allSpotsOfPlayer(isWhite: false)))
        XCTAssertFalse(board.isKingUnderCheck(enemySpotList: board.allSpotsOfPlayer(isWhite: true)))
    }
    
    func test_if_king_is_in_check_works() throws {
        initIsKingUnderCheck()
        
        board.getSpotById(id: "e7").piece = Rook(isWhite: false)
        XCTAssertTrue(board.isKingUnderCheck(enemySpotList: board.allSpotsOfPlayer(isWhite: false)))
        board.getSpotById(id: "e7").piece = Empty()
        board.getSpotById(id: "e2").piece = Rook(isWhite: true)
        XCTAssertTrue(board.isKingUnderCheck(enemySpotList: board.allSpotsOfPlayer(isWhite: true)))
    }
    
    /*
        AllSpotsOfPlayer
     */

    func test_if_it_selects_all_the_spots_where_the_white_player_has_a_piece() throws {
        let wPsSpots = [ board.board[7][0], board.board[7][1], board.board[7][2], board.board[7][3], board.board[7][4], board.board[7][5], board.board[7][6], board.board[7][7], board.board[6][0], board.board[6][1], board.board[6][2], board.board[6][3], board.board[6][4], board.board[6][5], board.board[6][6], board.board[6][7] ]
        let actualSpots = board.allSpotsOfPlayer(isWhite: true)
        
        for item in wPsSpots {
            XCTAssertTrue(actualSpots.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_it_selects_all_the_spots_where_the_black_player_has_a_piece() throws {
        let bPsSpots = [ board.board[0][0], board.board[0][1], board.board[0][2], board.board[0][3], board.board[0][4], board.board[0][5], board.board[0][6], board.board[0][7], board.board[0][0], board.board[0][1], board.board[0][2], board.board[0][3], board.board[0][4], board.board[0][5], board.board[0][6], board.board[0][7] ]
        let actualSpots = board.allSpotsOfPlayer(isWhite: false)
        
        for item in bPsSpots {
            XCTAssertTrue(actualSpots.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        Helper function
     */
    
    private func clearTable(b: Board) {
        for row in b.board {
            for spot in row {
                spot.piece = Empty()
            }
        }
    }
}
