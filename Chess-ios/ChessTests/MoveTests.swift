import XCTest
@testable import Chess

class MoveTests: XCTestCase {

    var player1: Player!
    var uciNotation1: String!
    var uciNotation2: String!
    var move1: Move!
    var move2: Move!
    
    override func setUp() {
        player1 = Player(isWhite: true)
        uciNotation1 = "e2e4"
        uciNotation2 = "d5d8q"
        move1 = Move(player: player1, chessNotation: uciNotation1)
        move2 = Move(player: player1, chessNotation: uciNotation2)
    }
    
    func test_if_the_from_value_is_correct() throws {
        XCTAssertEqual("e2", move1.from)
        XCTAssertEqual("d5", move2.from)
    }
    
    func test_if_the_to_value_is_correct() throws {
        XCTAssertEqual("e4", move1.to)
        XCTAssertEqual("d8", move2.to)
    }
    
    func test_if_the_promotion_value_is_correct() throws {
        XCTAssertNil(move1.promotion)
        XCTAssertEqual("q", move2.promotion)
    }
    
    func test_if_the_player_is_set() throws {
        XCTAssertIdentical(player1, move1.player)
        XCTAssertIdentical(player1, move2.player)
    }

}
