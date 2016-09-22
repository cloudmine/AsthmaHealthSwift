import UIKit
import MessageUI
import CMHealth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    fileprivate let mailViewController: MFMailComposeViewController? = {
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

        logOutButton.setBorder(width: 1.0, cornerRadius: 4.0)
        nameLabel.text = ""
        emailLabel.text = ""
        mailViewController?.mailComposeDelegate = self

        CMHUser.current().addObserver(self, forKeyPath: "userData", options: NSKeyValueObservingOptions.initial.union(.new), context: nil)
    }

    deinit {
        CMHUser.current().removeObserver(self, forKeyPath: "userData")
    }
}

// MARK: Target-Action

private extension ProfileViewController {

    @IBAction func didPressLogOut(_ sender: UIButton) {
        CMHUser.current().logout { error in
            if let error = error {
                alert(localizedMessage: NSLocalizedString("Error logging out", comment: ""), inViewController: self, withError: error)
                return
            }

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Unexpected App Delegate Class")
            }

            appDelegate.loadOnboarding()
        }
    }

    @IBAction func didPressWeb(_ sender: UIButton) {
        guard let cmURL = URL(string: "http://cloudmineinc.com") else {
            return
        }

        UIApplication.shared.openURL(cmURL)
    }

    @IBAction func didPressEmail(_ sender: UIButton) {
        guard let mailViewController = mailViewController else {
            alert(localizedMessage: NSLocalizedString("The mail app is not configured on your device.", comment: ""), inViewController: self)
            return
        }

        present(mailViewController, animated: true, completion: nil)
    }
}

// MARK: KVO

extension ProfileViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let user = object as? CMHUser,
            let keyPath = keyPath , keyPath == "userData",
            let userData = user.userData else {
                return
        }

        updateUI(with: userData)
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension ProfileViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        guard let _ = presentedViewController as? MFMailComposeViewController else {
            return
        }

        dismiss(animated: true, completion: nil)

        guard nil == error else {
            alert(localizedMessage: NSLocalizedString("Error sending email", comment: ""), inViewController: self, withError: error)
            return
        }

        if .sent == result {
            alert(localizedMessage: "Thank you for your feedback!", inViewController: self)
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
