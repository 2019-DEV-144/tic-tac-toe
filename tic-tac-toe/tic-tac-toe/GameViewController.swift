import UIKit

class GameViewController: UIViewController {
    
    private enum Constants {
        static let interCellSpacing: CGFloat = 8.0
    }

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    var gameLogic = GameLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.statusLabel.text = self.gameLogic.getCurrentTurnMessage()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        self.gameCollectionView.reloadData()
    }
    
    func changeTurn() {
        self.statusLabel.text = self.gameLogic.getCurrentTurnMessage()
    }
    
    func endGameInDraw() {
        self.statusLabel.text = self.gameLogic.getDrawMessage()
        self.gameCollectionView.isUserInteractionEnabled = false
    }
    
    func endGameinVictory() {
        self.statusLabel.text = self.gameLogic.getVictoryMessage()
        self.gameCollectionView.isUserInteractionEnabled = false
    }
    
    private func rowAndColumn(for indexPath: IndexPath) -> (row: Int, column: Int) {
        return (indexPath.row % gameLogic.columnCount, indexPath.row / gameLogic.columnCount)
    }

}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return gameLogic.rowCount * gameLogic.columnCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            SquareCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        
        let (row, column) = rowAndColumn(for: indexPath)
        
        if let square = cell as? SquareCollectionViewCell {
            square.setWithMark(self.gameLogic.markForPosition(row, column))
        }
        
        return cell
    }
    
    
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (row, column) = rowAndColumn(for: indexPath)
        switch self.gameLogic.selectPosition(row, column) {
        case .`continue`:
            changeTurn()
        case .draw:
            endGameInDraw()
        case .victory:
            endGameinVictory()
        case .invalid:
            return
        }
        self.gameCollectionView.reloadItems(at: [indexPath])
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
