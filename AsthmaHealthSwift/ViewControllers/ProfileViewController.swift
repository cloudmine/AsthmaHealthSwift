import UIKit
import MessageUI
import CMHealth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    private let mailViewController: MFMailComposeViewController? = {
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }

        let mailVC = MFMailComposeViewController()
        mailVC.setToRecipients(["sales@cloudmineinc.com"])
        mailVC.setSubject("CHC inquiry - AsthmaHealth")
        mailVC.setMessageBody("I would like to learn more about ResearchKit and the CloudMine Connected Health Cloud.", isHTML: false)

        return mailVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        logOutButton.setBorder(width: 1.0, corderRadius: 4.0)
        nameLabel.text = ""
        emailLabel.text = ""
        mailViewController?.mailComposeDelegate = self

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

    @IBAction func didPressWeb(sender: UIButton) {
        guard let cmURL = NSURL(string: "http://cloudmineinc.com") else {
            return
        }

        UIApplication.sharedApplication().openURL(cmURL)
    }

    @IBAction func didPressEmail(sender: UIButton) {
        guard let mailViewController = mailViewController else {
            "The mail app is not configured on your device.".alert(in: self)
            return
        }

        presentViewController(mailViewController, animated: true, completion: nil)
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

// MARK: MFMailComposeViewControllerDelegate

extension ProfileViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        guard let _ = presentedViewController as? MFMailComposeViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        guard nil == error else {
            "Error sending email".alert(in: self, withError: error)
            return
        }

        if MFMailComposeResultSent == result {
            "Thank you for your feedback!".alert(in: self)
        }
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
