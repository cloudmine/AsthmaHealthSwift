import UIKit
import CMHealth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.setBorder(width: 1.0, corderRadius: 4.0)
    }
}

// MARK: Target-Action

private extension ProfileViewController {

    @IBAction func didPressLogOut(sender: UIButton) {
        CMHUser.currentUser().logoutWithCompletion { error in
            if let error = error {
                "Error logging out".alert(in: self, withError: error)
                return
            }

            guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                fatalError("Unexpected App Delegate Class")
            }

            appDelegate.loadOnboarding()
        }
    }
}
