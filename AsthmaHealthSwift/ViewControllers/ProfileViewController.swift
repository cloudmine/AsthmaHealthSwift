import UIKit
import MessageUI
import CMHealth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signatureImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var viewConsentButton: UIButton!

    private var consent: CMHConsent? = nil
    private var cachedPDF: NSData? = nil

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

        [logOutButton, viewConsentButton].forEach { $0.setBorder(width: 1.0, corderRadius: 4.0) }
        nameLabel.text = ""
        emailLabel.text = ""
        mailViewController?.mailComposeDelegate = self

        CMHUser.currentUser().addObserver(self, forKeyPath: "userData", options: NSKeyValueObservingOptions.Initial.union(.New), context: nil)

        fetchConsent()
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

    @IBAction func didPressConsentDocument(sender: UIButton) {
        if let pdfData = cachedPDF {
            present(pdf: pdfData)
            return
        }

        consent?.fetchConsentPDFWithCompletion { (pdfData, error) in
            guard let pdfData = pdfData else {
                "There was an error downloading your consent document".alert(in: self, withError: error)
                return
            }

            self.present(pdf: pdfData)
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

    func fetchConsent() {
        CMHUser.currentUser().fetchUserConsentForStudyWithCompletion { (consent, error) in
            guard let consent = consent else {
                print("Error fetching consent: \(error?.localizedDescription)")
                return
            }

            self.consent = consent
            onMainThread {
                self.viewConsentButton.enabled = true
            }

            consent.fetchSignatureImageWithCompletion{ (sigImage, error) in
                guard let sigImage = sigImage else {
                    print("Failed to fetch signature image: \(error?.localizedDescription)")
                    return
                }

                onMainThread {
                    self.signatureImage.image = sigImage
                }
            }
        }
    }

    func present(pdf pdfData: NSData) {
        onMainThread {
            guard let pdfView = ShowPDFViewController.showing(pdf: pdfData) else {
                return
            }

            self.presentViewController(pdfView, animated: true, completion: nil)
        }
    }
}
