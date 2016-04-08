import UIKit
import CMHealth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Target-Action

private extension ProfileViewController {

    @IBAction func didPressLogOut(sender: UIButton) {
        CMHUser.currentUser().logoutWithCompletion { error in
            if let error = error {
                print("Error Logging Out: \(error.localizedDescription)") // TODO: Real error handling
                return
            }

            guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                fatalError("Unexpected App Delegate Class")
            }

            appDelegate.loadOnboarding()
        }
    }
}
