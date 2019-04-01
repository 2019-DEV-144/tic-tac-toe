import Foundation

class GameLogic {
    var player1Name = "Player 1"
    var player2Name = "Player 2"
    
    let rowCount = 3
    let columnCount = 3
    
    private(set) var currentPlayer = Mark.X
    private var gameIsOver = false
    private var dataSource: [Mark?]
    
    init() {
        self.dataSource = [Mark?](repeating: nil, count: rowCount * columnCount)
    }
    
    // MARK: - Messages
    func getCurrentTurnMessage() -> String {
        switch currentPlayer {
        case .X:
            return "\(player1Name)'s turn (X)"
        case .O:
            return "\(player2Name)'s turn (O)"
        }
    }
    
    func getDrawMessage() -> String {
        return "Draw"
    }
    
    func getVictoryMessage() -> String {
        switch currentPlayer {
        case .X:
            return "\(player1Name) Wins!"
        case .O:
            return "\(player2Name) Wins!"
        }
    }
    
    // MARK: - Game End Checks
    func isGameDrawn() -> Bool {
        return self.dataSource.filter({ $0 == nil }).count < 1
    }
    
    func isGameWon() -> Bool {
        // Check horizontal lines
        for i in 0..<rowCount {
            if (verifyLine { (index, _) in
                index >= (i * columnCount) && index < (i + 1) * columnCount
            }) {
                print("Victory in row \(i)")
                return true
            }
        }
        // Check vertical lines
        for i in 0..<columnCount {
            if (verifyLine { (index, _) in
                (index % columnCount) == i
            }) {
                print("Victory in column \(i)")
                return true
            }
        }
        // Check left-up diagonal
        if (verifyLine { (index, _) in
            index % (columnCount + 1) == 0
        }) {
            print("Victory in diagonal line (left-up)")
            return true
        }
        
        // Check left-down diagonal
        if (verifyLine { (index, _) in
            index != 0 && index != (rowCount * columnCount) - 1 && index % (columnCount - 1) == 0
        }) {
            print("Victory in diagonal line (left-down)")
            return true
        }
        
        return false
    }
    
    private func verifyLine(_ filter: (Int, Mark?) -> Bool) -> Bool {
        let candidateMarks = self.dataSource.enumerated().filter(filter)
        
        // Ensure all the marks are non-nil and are all the same
        return candidateMarks.dropFirst().allSatisfy {
            $0.element != nil && $0.element == candidateMarks.first?.element
        }
    }
    
    // MARK: - Gameplay
    private func dataSourceIndex(_ row: Int, _ column: Int) -> Int {
        return row + (column * self.columnCount)
    }
    
    func markForPosition(_ row: Int, _ column: Int) -> Mark? {
        guard row >= 0, row < self.rowCount, column >= 0, column < self.columnCount else {
            return nil
        }
        
        return dataSource[dataSourceIndex(row, column)]
    }
    
    func selectPosition(_ row: Int, _ column: Int) -> PlayResponse {
        guard row >= 0, row < self.rowCount, column >= 0, column < self.columnCount else {
            return .invalid
        }
        
        guard !self.gameIsOver else {
            return .invalid
        }
        
        // Check the selected cell has not already been marked
        guard self.dataSource[dataSourceIndex(row, column)] == nil else {
            return .invalid
        }
        
        self.dataSource[dataSourceIndex(row, column)] = self.currentPlayer
        
        if isGameWon() {
            self.gameIsOver = true
            return .victory
        } else if isGameDrawn() {
            self.gameIsOver = true
            return .draw
        } else {
            self.currentPlayer = self.currentPlayer.getOppositeMark()
            return .continue
        }
    }
}
