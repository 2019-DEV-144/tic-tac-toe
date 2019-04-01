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
        // Try each of the eight possible lines of three
        var victory = false
        
        // Top row
        if let topLeft = self.dataSource[0],
            let topMiddle = self.dataSource[1],
            let topRight = self.dataSource[2] {
            victory = victory || (topLeft == topMiddle && topLeft == topRight)
        }
        
        // Middle row
        if let middleLeft = self.dataSource[3],
            let centre = self.dataSource[4],
            let middleRight = self.dataSource[5] {
            victory = victory || (middleLeft == centre && middleLeft == middleRight)
        }
        
        // Bottom row
        if let bottomLeft = self.dataSource[6],
            let bottomMiddle = self.dataSource[7],
            let bottomRight = self.dataSource[8] {
            victory = victory || (bottomLeft == bottomMiddle && bottomLeft == bottomRight)
        }
        
        // Left column
        if let topLeft = self.dataSource[0],
            let middleLeft = self.dataSource[3],
            let bottomLeft = self.dataSource[6] {
            victory = victory || (topLeft == middleLeft && topLeft == bottomLeft)
        }
        
        // Middle column
        if let topMiddle = self.dataSource[1],
            let centre = self.dataSource[4],
            let bottomMiddle = self.dataSource[7] {
            victory = victory || (topMiddle == centre && topMiddle == bottomMiddle)
        }
        
        // Right column
        if let topRight = self.dataSource[2],
            let middleRight = self.dataSource[5],
            let bottomLeft = self.dataSource[8] {
            victory = victory || (topRight == middleRight && topRight == bottomLeft)
        }
        
        // Diagonal (left-up)
        if let topLeft = self.dataSource[0],
            let centre = self.dataSource[4],
            let bottomRight = self.dataSource[8] {
            victory = victory || (topLeft == centre && topLeft == bottomRight)
        }
        
        // Diagonal (left-down)
        if let topRight = self.dataSource[2],
            let centre = self.dataSource[4],
            let bottomLeft = self.dataSource[6] {
            victory = victory || (topRight == centre && topRight == bottomLeft)
        }
        
        return victory
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
