import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SquareCollectionViewCell"

    private var mark: Mark?
    var lineColour = UIColor.black
    
    private enum Constants {
        static let lineWidth: CGFloat = 8.0
    }
    
    func setWithMark(_ mark: Mark?) {
        self.mark = mark
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        switch self.mark {
        case .X?:
            let leftUpPath = UIBezierPath()
            leftUpPath.move(to: CGPoint(x: Constants.lineWidth,
                                        y: Constants.lineWidth))
            leftUpPath.addLine(to: CGPoint(x: rect.width - Constants.lineWidth,
                                           y: rect.height - Constants.lineWidth))
            leftUpPath.lineWidth = Constants.lineWidth
            lineColour.setStroke()
            leftUpPath.stroke()
            
            let rightUpPath = UIBezierPath()
            rightUpPath.move(to: CGPoint(x: rect.width - Constants.lineWidth,
                                         y: Constants.lineWidth))
            rightUpPath.addLine(to: CGPoint(x: Constants.lineWidth,
                                            y: rect.height - Constants.lineWidth))
            rightUpPath.lineWidth = Constants.lineWidth
            lineColour.setStroke()
            rightUpPath.stroke()
        case .O?:
            let insetRect = rect.insetBy(dx: Constants.lineWidth, dy: Constants.lineWidth)
            
            let circlePath = UIBezierPath(ovalIn: insetRect)
            circlePath.lineWidth = Constants.lineWidth
            lineColour.setStroke()
            circlePath.stroke()
        case nil:
            break
        }
    }

}
