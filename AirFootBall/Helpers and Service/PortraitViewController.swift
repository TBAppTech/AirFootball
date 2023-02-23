import UIKit

class PortraitViewController: UIViewController {
    var orientations = UIInterfaceOrientationMask.portrait //or what orientation you want
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self.orientations }
        set { self.orientations = newValue }
    }

}
