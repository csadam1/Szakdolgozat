import XCTest
@testable import Chess

class PlayerTests: XCTestCase {

    func test_if_the_constructor_works_well() throws {
        XCTAssertEqual(true, Player(isWhite: true).isWhite)
        XCTAssertEqual(false, Player(isWhite: false).isWhite)
    }

}
