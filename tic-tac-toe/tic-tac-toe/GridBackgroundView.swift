import UIKit

@IBDesignable
class GridBackgroundView: UIView {
    
    var lineColour = UIColor.black
    
    private enum Constants {
        static let lineWidth: CGFloat = 8.0
    }

    override func draw(_ rect: CGRect) {
        let gridPath = UIBezierPath()
        
        gridPath.move(to: CGPoint(x: rect.width / 3, y: 0))
        gridPath.addLine(to: CGPoint(x: rect.width / 3, y: rect.height))
        
        
        gridPath.move(to: CGPoint(x: 2 * rect.width / 3, y: 0))
        gridPath.addLine(to: CGPoint(x: 2 * rect.width / 3, y: rect.height))
        
        gridPath.move(to: CGPoint(x: 0, y: rect.height / 3))
        gridPath.addLine(to: CGPoint(x: rect.width, y: rect.height / 3))
        
        gridPath.move(to: CGPoint(x: 0, y: 2 * rect.height / 3))
        gridPath.addLine(to: CGPoint(x: rect.width, y: 2 * rect.height / 3))
        
        gridPath.lineWidth = Constants.lineWidth
        lineColour.setStroke()
        gridPath.stroke()
    }

}
