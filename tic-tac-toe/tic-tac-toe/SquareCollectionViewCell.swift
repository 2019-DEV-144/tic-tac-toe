import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SquareCollectionViewCell"

    @IBOutlet weak var markLabel: UILabel!
    
    func setWithMark(_ mark: Mark?) {
        switch mark {
        case .X?:
            self.markLabel.text = "X"
        case .O?:
            self.markLabel.text = "O"
        case nil:
            self.markLabel.text = "--"
        }
    }

}
