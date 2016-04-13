import UIKit
import CMHealth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        logOutButton.setBorder(width: 1.0, corderRadius: 4.0)
        nameLabel.text = ""
        emailLabel.text = ""

        CMHUser.currentUser().addObserver(self, forKeyPath: "userData", options: NSKeyValueObservingOptions.Initial.union(.New), context: nil)
    }

    deinit {
        CMHUser.currentUser().removeObserver(self, forKeyPath: "userData")
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

// MARK: KVO

extension ProfileViewController {

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let user = object as? CMHUser,
            let keyPath = keyPath where keyPath == "userData",
            let userData = user.userData else {
                return
        }

        updateUI(with: userData)
    }
}

// MARK: Private Helpers

private extension ProfileViewController {
    func updateUI(with userData: CMHUserData) {
        onMainThread {
            self.emailLabel.text = userData.email

            if let given = userData.givenName,
                let family = userData.familyName {
                self.nameLabel.text = "\(given) \(family)"
            }
        }
    }
}
