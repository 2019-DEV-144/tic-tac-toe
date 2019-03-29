import UIKit

class BeginViewController: UIViewController {
    @IBOutlet weak var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ""

        self.beginButton.layer.cornerRadius = self.beginButton.bounds.height / 2
        self.beginButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.beginButton.layer.shadowOpacity = 0.8
    }
}
