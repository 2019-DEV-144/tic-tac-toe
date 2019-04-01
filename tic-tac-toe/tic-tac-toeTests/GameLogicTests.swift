import XCTest

class GameLogicTests: XCTestCase {
    
    var gameLogic: GameLogic!

    override func setUp() {
        self.gameLogic = GameLogic()
    }

    // MARK: - Test messages
    func testStartingTurnMessage() {
        XCTAssertEqual(gameLogic.getCurrentTurnMessage(), "Player 1's turn (X)")
    }
    
    func testDrawMessage() {
        XCTAssertEqual(gameLogic.getDrawMessage(), "Draw")
    }
    
    func testVictoryMessage() {
        XCTAssertEqual(gameLogic.getVictoryMessage(), "Player 1 Wins!")
    }
    
    // MARK: - Test marks on board
    func testXGoesFirst() {
        XCTAssertEqual(gameLogic.currentPlayer, Mark.X)
    }
    
    func testBoardBeginsEmpty() {
        for i in 0..<gameLogic.rowCount {
            for j in 0..<gameLogic.columnCount {
                XCTAssertNil(gameLogic.markForPosition(i, j))
            }
        }
    }
    
    func testPlacingMark() {
        let playResponse = gameLogic.selectPosition(0, 0)
        XCTAssertEqual(playResponse, PlayResponse.continue)
        XCTAssertEqual(gameLogic.markForPosition(0, 0), Mark.X)
    }
    
    func testCannotPlayOnPlayedPosition() {
        _ = gameLogic.selectPosition(0, 0)
        let playResponse = gameLogic.selectPosition(0, 0)
        XCTAssertEqual(playResponse, PlayResponse.invalid)
        XCTAssertEqual(gameLogic.markForPosition(0, 0), Mark.X)
    }
    
    func testAlternatingMarks() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(0, 1)
        XCTAssertEqual(gameLogic.markForPosition(0, 1), Mark.O)
    }
    
    // MARK: - Test game-end conditions
    func testDrawWhenAllSpacesAreOccupied() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(1, 1)
        _ = gameLogic.selectPosition(1, 0)
        _ = gameLogic.selectPosition(2, 0)
        _ = gameLogic.selectPosition(0, 2)
        _ = gameLogic.selectPosition(0, 1)
        _ = gameLogic.selectPosition(2, 1)
        _ = gameLogic.selectPosition(1, 2)
        let playResponse = gameLogic.selectPosition(2, 2)
        XCTAssertEqual(playResponse, PlayResponse.draw)
        XCTAssert(gameLogic.isGameDrawn())
    }
    
    func testCannotPlayAfterDraw() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(1, 1)
        _ = gameLogic.selectPosition(1, 0)
        _ = gameLogic.selectPosition(2, 0)
        _ = gameLogic.selectPosition(0, 2)
        _ = gameLogic.selectPosition(0, 1)
        _ = gameLogic.selectPosition(2, 1)
        _ = gameLogic.selectPosition(1, 2)
        _ = gameLogic.selectPosition(2, 2)
        XCTAssert(gameLogic.isGameDrawn())
        let lastMark = gameLogic.markForPosition(2, 2)
        let playResponse = gameLogic.selectPosition(2, 2)
        XCTAssertEqual(playResponse, PlayResponse.invalid)
        XCTAssertEqual(gameLogic.markForPosition(2, 2), lastMark)
    }
    
    func testWinWithHorizontalLine() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(1, 0)
        _ = gameLogic.selectPosition(0, 1)
        _ = gameLogic.selectPosition(1, 1)
        let playResponse = gameLogic.selectPosition(0, 2)
        XCTAssertEqual(playResponse, PlayResponse.victory)
        XCTAssert(gameLogic.isGameWon())
    }
    
    func testWinWithVerticalLine() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(0, 1)
        _ = gameLogic.selectPosition(1, 0)
        _ = gameLogic.selectPosition(1, 1)
        _ = gameLogic.selectPosition(0, 2)
        let playResponse = gameLogic.selectPosition(2, 1)
        XCTAssertEqual(playResponse, PlayResponse.victory)
        XCTAssert(gameLogic.isGameWon())
    }
    
    func testWinWithDiagonalLineLeftUp() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(0, 1)
        _ = gameLogic.selectPosition(1, 1)
        _ = gameLogic.selectPosition(1, 2)
        let playResponse = gameLogic.selectPosition(2, 2)
        XCTAssertEqual(playResponse, PlayResponse.victory)
        XCTAssert(gameLogic.isGameWon())
    }
    
    func testWinWithDiagonalLineLeftDown() {
        _ = gameLogic.selectPosition(1, 0)
        _ = gameLogic.selectPosition(0, 2)
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(1, 1)
        _ = gameLogic.selectPosition(0, 1)
        let playResponse = gameLogic.selectPosition(2, 0)
        XCTAssertEqual(playResponse, PlayResponse.victory)
        XCTAssert(gameLogic.isGameWon())
    }
    
    func testCannotPlayAfterVictory() {
        _ = gameLogic.selectPosition(0, 0)
        _ = gameLogic.selectPosition(1, 0)
        _ = gameLogic.selectPosition(0, 1)
        _ = gameLogic.selectPosition(1, 1)
        _ = gameLogic.selectPosition(0, 2)
        XCTAssert(gameLogic.isGameWon())
        
        let playResponse = gameLogic.selectPosition(0, 0)
        XCTAssertEqual(playResponse, PlayResponse.invalid)
        
        // Test that a mark cannot be placed even in an unoccupied space
        let bottomRightMark = gameLogic.markForPosition(2, 2)
        let playResponse2 = gameLogic.selectPosition(2, 2)
        XCTAssertEqual(playResponse2, PlayResponse.invalid)
        XCTAssertEqual(gameLogic.markForPosition(2, 2), bottomRightMark)
    }

}
