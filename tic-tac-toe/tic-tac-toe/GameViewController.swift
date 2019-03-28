import UIKit

class GameViewController: UIViewController {
    
    private enum Constants {
        static let interCellSpacing: CGFloat = 8.0
    }

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    var currentPlayer = Mark.X
    var gameIsOver = false
    
    var dataSource = [Mark?](repeating: nil, count: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gameCollectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier:
            SquareCollectionViewCell.reuseIdentifier)
        
        self.gameCollectionView.dataSource = self
        self.gameCollectionView.delegate = self
        
        if let flowLayout =
            self.gameCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let oneThirdSquare = min(self.view.bounds.width, self.view.bounds.height) / 3
                - Constants.interCellSpacing
            flowLayout.estimatedItemSize = CGSize(width: oneThirdSquare, height: oneThirdSquare)
        }
        
        self.navigationItem.title = ""
        self.statusLabel.text = "Player 1's Turn"
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        self.gameCollectionView.reloadData()
    }
    
    func changeTurn() {
        self.currentPlayer = self.currentPlayer.getOppositeMark()
        
        // Set the status label to denote which player's turn it is
        switch self.currentPlayer {
        case .X:
            self.statusLabel.text = "Player 1's Turn"
        case .O:
            self.statusLabel.text = "Player 2's Turn"
        }
    }
    
    func isGameDrawn() -> Bool {
        return self.dataSource.filter({ $0 == nil }).count < 1
    }
    
    func endGameInDraw() {
        self.gameIsOver = true
        self.statusLabel.text = "Draw"
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
    
    func endGameinVictory() {
        self.gameIsOver = true
        switch self.currentPlayer {
        case .X:
            self.statusLabel.text = "Player 1 wins!"
        case .O:
            self.statusLabel.text = "Player 2 wins!"
        }
    }

}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            SquareCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        
        if let square = cell as? SquareCollectionViewCell {
            square.setWithMark(self.dataSource[indexPath.row])
        }
        
        return cell
    }
    
    
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !self.gameIsOver else {
            return
        }
        
        // Check the selected cell has not already been marked
        guard self.dataSource[indexPath.row] == nil else {
            return
        }
        
        self.dataSource[indexPath.row] = self.currentPlayer
        self.gameCollectionView.reloadItems(at: [indexPath])
        
        if isGameWon() {
            endGameinVictory()
        } else if isGameDrawn() {
            endGameInDraw()
        } else {
            changeTurn()
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
            // Set the cell size so as to create a 3x3 grid
            return CGSize(width: collectionView.bounds.width / 3
                - GameViewController.Constants.interCellSpacing,
                          height: collectionView.bounds.height / 3
                            - GameViewController.Constants.interCellSpacing)
    }
}
