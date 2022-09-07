import XCTest
@testable import Chess

class PieceTests: XCTestCase {

    var board: Board!
    
    override func setUp() {
        board = Board()
    }
    
    override func tearDown() {
        board = Board()
    }
    
    /*
        King
     */
    
    func initKing() {
        for row in board.board {
            for spot in row {
                spot.piece = Empty()
            }
        }
        board.getSpotById(id: "e8").piece = King(isWhite: false)
        board.getSpotById(id: "e4").piece = King(isWhite: true)
        board.getSpotById(id: "h8").piece = King(isWhite: true)
        board.getSpotById(id: "a1").piece = King(isWhite: true)
        
        board.castPerm = "-"
    }
    
    /*
        Constructor
     */
    
    func test_if_the_character_of_white_king_is_K() throws {
        initKing()
        
        let kingP = King(isWhite: true)
        XCTAssertEqual("K", kingP.char)
    }
    
    func test_if_the_character_of_black_king_is_k() throws {
        initKing()
        
        let kingP = King(isWhite: false)
        XCTAssertEqual("k", kingP.char)
    }
    
    /*
        PossibleMoves
     */
    
    func test_if_king_can_step_without_going_out_of_table() throws {
        initKing()
        
        let expectedValueList1 = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "e5"), board.getSpotById(id: "f5"), board.getSpotById(id: "d4"), board.getSpotById(id: "f4"), board.getSpotById(id: "d3"), board.getSpotById(id: "e3"), board.getSpotById(id: "f3")
        ].map { $0 }
        let moveList1 = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        
        for item in moveList1 {
            XCTAssertTrue(expectedValueList1.first { return $0.id == item.id } != nil)
        }
        
        let expectedValueList2 = [
            board.getSpotById(id: "g8"), board.getSpotById(id: "g7"), board.getSpotById(id: "h7")
        ].map { $0 }
        let moveList2 = board.getSpotById(id: "h8").piece.possibleMoves(board: board)
        
        for item in moveList2 {
            XCTAssertTrue(expectedValueList2.first { return $0.id == item.id } != nil)
        }
        
        let expectedValueList3 = [
            board.getSpotById(id: "a2"), board.getSpotById(id: "b2"), board.getSpotById(id: "b1")
        ].map { $0 }
        let moveList3 = board.getSpotById(id: "a1").piece.possibleMoves(board: board)
        
        for item in moveList3 {
            XCTAssertTrue(expectedValueList3.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_king_can_step_without_hitting_any_friendly_piece() throws {
        initKing()
        
        board.getSpotById(id: "d5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "e5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f5").piece = Pawn(isWhite: true)
        
        board.getSpotById(id: "d4").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f4").piece = Pawn(isWhite: true)
        
        board.getSpotById(id: "d3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "e3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f3").piece = Pawn(isWhite: true)
        
        let moveList1 = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList1.isEmpty)
        
        board.getSpotById(id: "g8").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "h7").piece = Pawn(isWhite: true)
        
        let moveList2 = board.getSpotById(id: "h8").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
        
        board.getSpotById(id: "a2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b1").piece = Pawn(isWhite: true)
        
        let moveList3 = board.getSpotById(id: "a1").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList3.isEmpty)
    }
    
    func test_if_king_can_step_without_hitting_any_enemy_piece() throws {
        initKing()
        
        board.getSpotById(id: "d5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "e5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f5").piece = Pawn(isWhite: false)
        
        board.getSpotById(id: "d4").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f4").piece = Pawn(isWhite: false)
        
        board.getSpotById(id: "d3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "e3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f3").piece = Pawn(isWhite: false)
        
        let moveList1 = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList1.isEmpty)
        
        board.getSpotById(id: "g8").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "h7").piece = Pawn(isWhite: false)
        
        let moveList2 = board.getSpotById(id: "h8").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
        
        board.getSpotById(id: "a2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b1").piece = Pawn(isWhite: false)
        
        let moveList3 = board.getSpotById(id: "a1").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList3.isEmpty)
    }
    
    func test_if_castle_permission_works_well() throws {
        initKing()
        
        board.getSpotById(id: "a1").piece = Rook(isWhite: true)
        board.getSpotById(id: "h1").piece = Rook(isWhite: true)
        board.getSpotById(id: "e1").piece = King(isWhite: true)
        board.castPerm = "KQ"
        
        let expectedValueList = [board.getSpotById(id: "c1"), board.getSpotById(id: "g1")]
        let moveList = board.getSpotById(id: "e1").piece.possibleMoves(board: board)

        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        PossibleCaptureMoves
     */
    
    func test_if_king_can_not_capture_friendly_pieces() throws {
        initKing()
        
        board.getSpotById(id: "d5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "e5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f5").piece = Pawn(isWhite: true)
        
        board.getSpotById(id: "d4").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f4").piece = Pawn(isWhite: true)
        
        board.getSpotById(id: "d3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "e3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f3").piece = Pawn(isWhite: true)
        
        let moveList1 = board.getSpotById(id: "e4").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList1.isEmpty)
        
        board.getSpotById(id: "g8").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "h7").piece = Pawn(isWhite: true)
        
        let moveList2 = board.getSpotById(id: "h8").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
        
        board.getSpotById(id: "a2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b1").piece = Pawn(isWhite: true)
        
        let moveList3 = board.getSpotById(id: "a1").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList3.isEmpty)
    }
    
    func test_if_it_can_capture_enemy_pieces() throws {
        initKing()
        
        board.getSpotById(id: "d5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "e5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f5").piece = Pawn(isWhite: false)
        
        board.getSpotById(id: "d4").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f4").piece = Pawn(isWhite: false)
        
        board.getSpotById(id: "d3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "e3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f3").piece = Pawn(isWhite: false)
        
        let expectedValueList1 = [
            board.getSpotById(id: "d5"),
            board.getSpotById(id: "e5"),
            board.getSpotById(id: "f5"),
            board.getSpotById(id: "d4"),
            board.getSpotById(id: "f4"),
            board.getSpotById(id: "d3"),
            board.getSpotById(id: "e3"),
            board.getSpotById(id: "f3")
        ]
        let moveList1 = board.getSpotById(id: "e4").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList1 {
            XCTAssertTrue(moveList1.first { return $0.id == item.id } != nil)
        }
        
        
        board.getSpotById(id: "g8").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "h7").piece = Pawn(isWhite: false)
        
        let expectedValueList2 = [
            board.getSpotById(id: "g8"),
            board.getSpotById(id: "g7"),
            board.getSpotById(id: "h7")
        ]
        let moveList2 = board.getSpotById(id: "h8").piece.possibleCaptureMoves(board: board)

        for item in expectedValueList2 {
            XCTAssertTrue(moveList2.first { return $0.id == item.id } != nil)
        }
        
        
        board.getSpotById(id: "a2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b1").piece = Pawn(isWhite: false)
        
        let expectedValueList3 = [
            board.getSpotById(id: "a2"),
            board.getSpotById(id: "b2"),
            board.getSpotById(id: "b1")
        ]
        let moveList3 = board.getSpotById(id: "a1").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList3 {
            XCTAssertTrue(moveList3.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        Queen
     */
    
    func initQueen() {
        for row in board.board {
            for spot in row {
                if type(of: spot.piece) != type(of: King()) {
                    spot.piece = Empty()
                }
            }
        }
        board.getSpotById(id: "d4").piece = Queen(isWhite: true)
    }
    
    /*
        Constructor
     */
    
    func test_if_the_character_of_white_queen_is_Q() throws {
        initQueen()
        
        let queenP = Queen(isWhite: true)
        XCTAssertEqual("Q", queenP.char)
    }
    
    func test_if_the_character_of_black_queen_is_q() throws {
        initQueen()
        
        let queenP = Queen(isWhite: false)
        XCTAssertEqual("q", queenP.char)
    }
    
    /*
        PossibleMoves
     */
    
    func test_if_queen_can_go_horizontal_vertical_and_diagonal_without_going_out_of_table() throws {
        initQueen()
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "d6"), board.getSpotById(id: "d7"), board.getSpotById(id: "d8"), board.getSpotById(id: "d3"), board.getSpotById(id: "d2"), board.getSpotById(id: "d1"), board.getSpotById(id: "c4"), board.getSpotById(id: "b4"), board.getSpotById(id: "a4"), board.getSpotById(id: "e4"), board.getSpotById(id: "f4"), board.getSpotById(id: "g4"), board.getSpotById(id: "h4"),
            
                board.getSpotById(id: "c5"), board.getSpotById(id: "b6"), board.getSpotById(id: "a7"), board.getSpotById(id: "c3"), board.getSpotById(id: "b2"), board.getSpotById(id: "a1"), board.getSpotById(id: "e3"), board.getSpotById(id: "f2"), board.getSpotById(id: "g1"), board.getSpotById(id: "e5"), board.getSpotById(id: "f6"), board.getSpotById(id: "g7"), board.getSpotById(id: "h8")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_queen_can_go_horizontal_vertical_and_diagonal_without_going_through_or_hitting_any_friendly_piece() throws {
        initQueen()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: true)
        
        board.getSpotById(id: "b6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: true)
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "d3"), board.getSpotById(id: "c4"), board.getSpotById(id: "e4"), board.getSpotById(id: "f4"), board.getSpotById(id: "c5"), board.getSpotById(id: "e3"), board.getSpotById(id: "e5"), board.getSpotById(id: "f6")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_queen_can_go_horizontal_vertical_and_diagonal_without_going_through_or_hitting_any_enemy_piece() throws {
        initQueen()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: false)
        
        board.getSpotById(id: "b6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: false)
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "d3"), board.getSpotById(id: "c4"), board.getSpotById(id: "e4"), board.getSpotById(id: "f4"), board.getSpotById(id: "c5"), board.getSpotById(id: "e3"), board.getSpotById(id: "e5"), board.getSpotById(id: "f6")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        PossibleCaptureMoves
     */
    
    func test_if_queen_can_not_capture_friendly_pieces() throws {
        initQueen()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: true)
        
        board.getSpotById(id: "b6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: true)
        
        let moveList = board.getSpotById(id: "d4").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList.isEmpty)
    }
    
    func test_if_queen_can_capture_enemy_pieces() throws {
        initQueen()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: false)
        
        board.getSpotById(id: "b6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: false)
        
        let expectedValueList = [
            board.getSpotById(id: "d2"), board.getSpotById(id: "d6"), board.getSpotById(id: "g4"), board.getSpotById(id: "b4"), board.getSpotById(id: "b6"), board.getSpotById(id: "g7"), board.getSpotById(id: "f2"), board.getSpotById(id: "c3")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        Rook
     */
    
    func initRook() {
        for row in board.board {
            for spot in row {
                if type(of: spot.piece) != type(of: King()) {
                    spot.piece = Empty()
                }
            }
        }
        board.getSpotById(id: "d4").piece = Rook(isWhite: true)
    }
    
    /*
        Constructor
     */
    
    func test_if_the_character_of_white_rook_is_R() throws {
        initRook()
        
        let rookP = Rook(isWhite: true)
        XCTAssertEqual("R", rookP.char)
    }
    
    func test_if_the_character_of_black_rook_is_r() throws {
        initRook()
        
        let rookP = Rook(isWhite: false)
        XCTAssertEqual("r", rookP.char)
    }
    
    /*
        PossibleMoves
     */
    
    func test_if_rook_can_go_horizontal_and_vertical_without_going_out_of_table() throws {
        initRook()
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "d6"), board.getSpotById(id: "d7"), board.getSpotById(id: "d8"), board.getSpotById(id: "d3"), board.getSpotById(id: "d2"), board.getSpotById(id: "d1"), board.getSpotById(id: "c4"), board.getSpotById(id: "b4"), board.getSpotById(id: "a4"), board.getSpotById(id: "e4"), board.getSpotById(id: "f4"), board.getSpotById(id: "g4"), board.getSpotById(id: "h4")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_rook_can_go_horizontal_and_vertical_without_going_through_or_hitting_any_friendly_piece() throws {
        initRook()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: true)
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "d3"), board.getSpotById(id: "c4"), board.getSpotById(id: "e4"), board.getSpotById(id: "f4")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_rook_can_go_horizontal_and_vertical_without_going_through_or_hitting_any_enemy_piece() throws {
        initRook()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: false)
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "d3"), board.getSpotById(id: "c4"), board.getSpotById(id: "e4"), board.getSpotById(id: "f4")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        PossibleCaptureMoves
     */
    
    func test_if_rook_can_not_capture_friendly_pieces() throws {
        initRook()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: true)

        let moveList = board.getSpotById(id: "d4").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList.isEmpty)
    }
    
    func test_if_rook_can_capture_enemy_pieces() throws {
        initRook()
        
        board.getSpotById(id: "d2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g4").piece = Pawn(isWhite: false)
        board.getSpotById(id: "b4").piece = Pawn(isWhite: false)
        
        let expectedValueList = [
            board.getSpotById(id: "d2"), board.getSpotById(id: "d6"), board.getSpotById(id: "g4"), board.getSpotById(id: "b4")
        ]
        let moveList = board.getSpotById(id: "d4").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        Knight
     */
    
    func initKnight() {
        for row in board.board {
            for spot in row {
                if type(of: spot.piece) != type(of: King()) {
                    spot.piece = Empty()
                }
            }
        }
        board.getSpotById(id: "e4").piece = Knight(isWhite: true)
        board.getSpotById(id: "a1").piece = Knight(isWhite: true)
        board.getSpotById(id: "h8").piece = Knight(isWhite: true)
    }
    
    /*
        Constructor
     */
    
    func test_if_the_character_of_white_knight_is_N() throws {
        initKnight()
        
        let knightP = Knight(isWhite: true)
        XCTAssertEqual("N", knightP.char)
    }
    
    func test_if_the_character_of_black_knight_is_n() throws {
        initKnight()
        
        let knightP = Knight(isWhite: false)
        XCTAssertEqual("n", knightP.char)
    }
    
    /*
        PossibleMoves
     */
    
    func test_if_knight_can_jump_in_an_L_shape_without_going_out_of_table() throws {
        initKnight()
        
        let expectedValueList1 = [
            board.getSpotById(id: "d6"), board.getSpotById(id: "f6"), board.getSpotById(id: "c5"), board.getSpotById(id: "g5"), board.getSpotById(id: "c3"), board.getSpotById(id: "g3"), board.getSpotById(id: "d2"), board.getSpotById(id: "f2")
        ]
        let moveList1 = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        
        for item in expectedValueList1 {
            XCTAssertTrue(moveList1.first { return $0.id == item.id } != nil)
        }
        
        let expectedValueList2 = [
            board.getSpotById(id: "f7"), board.getSpotById(id: "g6")
        ]
        let moveList2 = board.getSpotById(id: "h8").piece.possibleMoves(board: board)
        
        for item in expectedValueList2 {
            XCTAssertTrue(moveList2.first { return $0.id == item.id } != nil)
        }
        
        let expectedValueList3 = [
            board.getSpotById(id: "b3"), board.getSpotById(id: "c2")
        ]
        let moveList3 = board.getSpotById(id: "a1").piece.possibleMoves(board: board)
        
        for item in expectedValueList3 {
            XCTAssertTrue(moveList3.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_knight_can_jump_in_an_L_shape_without_hitting_any_friendly_piece() throws {
        initKnight()
        
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: true)
        
        let moveList1 = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList1.isEmpty)
        
        board.getSpotById(id: "f7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: true)

        let moveList2 = board.getSpotById(id: "h8").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
        
        board.getSpotById(id: "b3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c2").piece = Pawn(isWhite: true)

        let moveList3 = board.getSpotById(id: "a1").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList3.isEmpty)
    }
    
    func test_if_knight_can_jump_in_an_L_shape_without_hitting_any_enemy_piece() throws {
        initKnight()
        
        board.getSpotById(id: "d6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: false)
        
        let moveList1 = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList1.isEmpty)
        
        board.getSpotById(id: "f7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: false)

        let moveList2 = board.getSpotById(id: "h8").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
        
        board.getSpotById(id: "b3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c2").piece = Pawn(isWhite: false)

        let moveList3 = board.getSpotById(id: "a1").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList3.isEmpty)
    }
    
    /*
        PossibleCaptureMoves
     */
    
    func test_if_knight_can_not_capture_friendly_pieces() throws {
        initKnight()
        
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: true)
        
        let moveList1 = board.getSpotById(id: "e4").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList1.isEmpty)
        
        board.getSpotById(id: "f7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: true)

        let moveList2 = board.getSpotById(id: "h8").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
        
        board.getSpotById(id: "b3").piece = Pawn(isWhite: true)
        board.getSpotById(id: "c2").piece = Pawn(isWhite: true)

        let moveList3 = board.getSpotById(id: "a1").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList3.isEmpty)
    }
    
    func test_if_knight_can_capture_enemy_pieces() throws {
        initKnight()
        
        board.getSpotById(id: "d6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g5").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "f2").piece = Pawn(isWhite: false)
        
        let expectedValueList1 = [
            board.getSpotById(id: "d6"), board.getSpotById(id: "f6"), board.getSpotById(id: "c5"), board.getSpotById(id: "g5"), board.getSpotById(id: "c3"), board.getSpotById(id: "g3"), board.getSpotById(id: "d2"), board.getSpotById(id: "f2")
        ]
        let moveList1 = board.getSpotById(id: "e4").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList1 {
            XCTAssertTrue(moveList1.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "f7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: false)

        let expectedValueList2 = [
            board.getSpotById(id: "f7"), board.getSpotById(id: "g6")
        ]
        let moveList2 = board.getSpotById(id: "h8").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList2 {
            XCTAssertTrue(moveList2.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "b3").piece = Pawn(isWhite: false)
        board.getSpotById(id: "c2").piece = Pawn(isWhite: false)

        let expectedValueList3 = [
            board.getSpotById(id: "b3"), board.getSpotById(id: "c2")
        ]
        let moveList3 = board.getSpotById(id: "a1").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList3 {
            XCTAssertTrue(moveList3.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        Bishop
     */
    
    func initBishop() {
        for row in board.board {
            for spot in row {
                if type(of: spot.piece) != type(of: King()) {
                    spot.piece = Empty()
                }
            }
        }
        board.getSpotById(id: "e4").piece = Bishop(isWhite: true)
    }
    
    /*
        Constructor
     */
    
    func test_if_the_character_of_white_bishop_is_B() throws {
        initBishop()
        
        let bishopP = Bishop(isWhite: true)
        XCTAssertEqual("B", bishopP.char)
    }
    
    func test_if_the_character_of_black_bishop_is_q() throws {
        initBishop()
        
        let bishopP = Bishop(isWhite: false)
        XCTAssertEqual("b", bishopP.char)
    }
    
    /*
        PossibleMoves
     */
    
    func test_if_bishop_can_go_diagonal_without_going_out_of_table() throws {
        initBishop()
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "c6"), board.getSpotById(id: "b7"), board.getSpotById(id: "a8"), board.getSpotById(id: "f5"), board.getSpotById(id: "g6"), board.getSpotById(id: "h7"), board.getSpotById(id: "f3"), board.getSpotById(id: "g2"), board.getSpotById(id: "h1"), board.getSpotById(id: "d3"), board.getSpotById(id: "c2"), board.getSpotById(id: "b1")
        ]
        let moveList = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_bishop_can_go_diagonal_without_going_through_or_hitting_any_friendly_piece() throws {
        initBishop()
        
        board.getSpotById(id: "b7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d3").piece = Pawn(isWhite: true)
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "c6"), board.getSpotById(id: "f5"), board.getSpotById(id: "f3")
        ]
        let moveList = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_bishop_can_go_diagonal_without_going_through_or_hitting_any_enemy_piece() throws {
        initBishop()
        
        board.getSpotById(id: "b7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d3").piece = Pawn(isWhite: false)
        
        let expectedValueList = [
            board.getSpotById(id: "d5"), board.getSpotById(id: "c6"), board.getSpotById(id: "f5"), board.getSpotById(id: "f3")
        ]
        let moveList = board.getSpotById(id: "e4").piece.possibleMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        PossibleCaptureMoves
     */
    
    func test_if_bishop_can_not_capture_friendly_pieces() throws {
        initBishop()
        
        board.getSpotById(id: "b7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "g2").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d3").piece = Pawn(isWhite: true)
        
        let moveList = board.getSpotById(id: "e4").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(moveList.isEmpty)
    }
    
    func test_if_bishop_can_capture_enemy_pieces() throws {
        initBishop()
        
        board.getSpotById(id: "b7").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g6").piece = Pawn(isWhite: false)
        board.getSpotById(id: "g2").piece = Pawn(isWhite: false)
        board.getSpotById(id: "d3").piece = Pawn(isWhite: false)
        
        let expectedValueList = [
            board.getSpotById(id: "b7"), board.getSpotById(id: "g6"), board.getSpotById(id: "g2"), board.getSpotById(id: "d3")
        ]
        let moveList = board.getSpotById(id: "e4").piece.possibleCaptureMoves(board: board)
        
        for item in expectedValueList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        Pawn
     */
    
    /*
        Constructor
     */
    
    func test_if_the_character_of_white_pawn_is_P() throws {
        let pawnP = Pawn(isWhite: true)
        XCTAssertEqual("P", pawnP.char)
    }
    
    func test_if_the_character_of_black_pawn_is_p() throws {
        let pawnP = Pawn(isWhite: false)
        XCTAssertEqual("p", pawnP.char)
    }
    
    /*
        PossibleMoves
     */
    
    func test_if_pawn_can_advance_2_steps_forward_from_starting_position() throws {
        let moveList = board.getSpotById(id: "a2").piece.possibleMoves(board: board)
        let expectedMoveList = [ board.getSpotById(id: "a3"), board.getSpotById(id: "a4") ]
        
        for item in expectedMoveList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
        
        let moveList2 = board.getSpotById(id: "b2").piece.possibleMoves(board: board)
        let expectedMoveList2 = [ board.getSpotById(id: "b3"), board.getSpotById(id: "b4") ]
        
        for item in expectedMoveList2 {
            XCTAssertTrue(moveList2.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_pawn_can_advance_1_step_when_blocked_from_the_2nd_square() throws {
        board.getSpotById(id: "c4").piece = Rook(isWhite: true)
        let moveList = board.getSpotById(id: "c2").piece.possibleMoves(board: board)
        let expectedMoveList = [ board.getSpotById(id: "c3") ]
        
        for item in expectedMoveList {
            XCTAssertTrue(moveList.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "d4").piece = Rook(isWhite: true)
        let moveList2 = board.getSpotById(id: "d2").piece.possibleMoves(board: board)
        let expectedMoveList2 = [ board.getSpotById(id: "d3") ]
        
        for item in expectedMoveList2 {
            XCTAssertTrue(moveList2.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_pawn_can_not_advanced_when_blocked_from_front() throws {
        board.getSpotById(id: "c3").piece = Rook(isWhite: true)
        let moveList = board.getSpotById(id: "c2").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList.isEmpty)
        
        board.getSpotById(id: "d3").piece = Rook(isWhite: true)
        let moveList2 = board.getSpotById(id: "d2").piece.possibleMoves(board: board)
        XCTAssertTrue(moveList2.isEmpty)
    }
    
    func test_if_pawn_can_advance_only_1_square_from_every_other_spots_than_the_starting_position() throws {
        board.getSpotById(id: "a3").piece = Pawn(isWhite: true)
        let moveList1 = board.getSpotById(id: "a3").piece.possibleMoves(board: board)
        let expectedMoveList1 = [board.getSpotById(id: "a4")]
        
        for item in expectedMoveList1 {
            XCTAssertTrue(moveList1.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "b4").piece = Pawn(isWhite: true)
        let moveList2 = board.getSpotById(id: "b4").piece.possibleMoves(board: board)
        let expectedMoveList2 = [board.getSpotById(id: "b5")]
        
        for item in expectedMoveList2 {
            XCTAssertTrue(moveList2.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "c5").piece = Pawn(isWhite: true)
        let moveList3 = board.getSpotById(id: "c5").piece.possibleMoves(board: board)
        let expectedMoveList3 = [board.getSpotById(id: "c6")]
        
        for item in expectedMoveList3 {
            XCTAssertTrue(moveList3.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "d6").piece = Pawn(isWhite: true)
        board.getSpotById(id: "d7").piece = Empty()
        let moveList4 = board.getSpotById(id: "d6").piece.possibleMoves(board: board)
        let expectedMoveList4 = [board.getSpotById(id: "d7")]
        
        for item in expectedMoveList4 {
            XCTAssertTrue(moveList4.first { return $0.id == item.id } != nil)
        }
        
        board.getSpotById(id: "a7").piece = Pawn(isWhite: true)
        board.getSpotById(id: "a8").piece = Empty()
        let moveList5 = board.getSpotById(id: "a7").piece.possibleMoves(board: board)
        let expectedMoveList5 = [board.getSpotById(id: "a8")]
        
        for item in expectedMoveList5 {
            XCTAssertTrue(moveList5.first { return $0.id == item.id } != nil)
        }
    }
    
    /*
        PossibleCaptureMoves
     */

    func test_if_left_diagonal_capture_move_works() throws {
        board.getSpotById(id: "b3").piece = Rook(isWhite: false)
        let captureMoveList = board.getSpotById(id: "c2").piece.possibleCaptureMoves(board: board)
        let b3List = [board.getSpotById(id: "b3")]
        for item in b3List {
            XCTAssertTrue(captureMoveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_right_diagonal_capture_move_works() throws {
        board.getSpotById(id: "b3").piece = Rook(isWhite: false)
        let captureMoveList = board.getSpotById(id: "a2").piece.possibleCaptureMoves(board: board)
        let b3List = [board.getSpotById(id: "b3")]
        
        for item in b3List {
            XCTAssertTrue(captureMoveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_the_En_Passant_square_is_capturable() throws {
        board.getSpotById(id: "b3").piece = Rook(isWhite: false)
        board.getSpotById(id: "a5").piece = Pawn(isWhite: true)
        board.getSpotById(id: "b7").piece = Empty()
        board.getSpotById(id: "b5").piece = Pawn(isWhite: false)
        board.enPas = "b6"
        
        let captureMoveList = board.getSpotById(id: "a5").piece.possibleCaptureMoves(board: board)
        let expectedList = [board.getSpotById(id: "b6")]
        
        for item in expectedList {
            XCTAssertTrue(captureMoveList.first { return $0.id == item.id } != nil)
        }
    }
    
    func test_if_pawn_can_not_attack_forward() throws {
        board.getSpotById(id: "b3").piece = Rook(isWhite: false)
        board.getSpotById(id: "e3").piece = Rook(isWhite: false)
        
        let captureMovelist = board.getSpotById(id: "e2").piece.possibleCaptureMoves(board: board)
        XCTAssertTrue(captureMovelist.isEmpty)
    }
    
    /*
        Empty
     */
    
    /*
        Constructor
     */
    
    func test_if_the_empty_pieces_character_is_empty() throws {
        let emptyP = Empty()
        XCTAssertEqual("-", emptyP.char)
    }
    
    /*
        PossibleMoves and PossibleCaptureMoves
     */
    
    func test_if_the_possible_move_list_is_empty() throws {
        let board = Board()
        let emptyP = Empty()
        
        XCTAssertTrue(emptyP.possibleMoves(board: board).isEmpty)
        XCTAssertTrue(emptyP.possibleCaptureMoves(board: board).isEmpty)
    }
    
}
