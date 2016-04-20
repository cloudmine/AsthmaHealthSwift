import UIKit
import CMHealth

class OnboardingViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    private var consentResult: ORKTaskResult? = nil
    private var consentDocument: ORKConsentDocument? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        joinButton.setBorder(width: 1.0, corderRadius: 4.0)
        removeNavigationBarDropShadow()
    }
}

// MARK: Private
private extension OnboardingViewController {

    func signup(email email: String, password: String) {
        CMHUser.currentUser().signUpWithEmail(email, password: password) { signupError in
            if let signupError = signupError {
                "Error during signup".alert(in: self.presentedViewController, withError:signupError)
                return
            }

            CMHUser.currentUser().uploadUserConsent(self.consentResult){ (consent, uploadError) in
                guard let consent = consent else {
                    "Error during signup while uploading consent".alert(in: self.presentedViewController, withError: uploadError)
                    return
                }

                self.uploadPDF(fromConsent: consent) { pdfError in
                    guard nil == pdfError else {
                        "Error creating and uploading your consent PDF document".alert(in: self, withError: uploadError)
                        return
                    }

                    guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                        fatalError("Unexpected App Delegate Class")
                    }

                    appDelegate.loadMainPanel()
                }
            }
        }
    }

    func uploadPDF(fromConsent consent: CMHConsent, block: (NSError?) -> ()) {
        guard let consentDoc = self.consentDocument,
            let signatureResult: ORKConsentSignatureResult = self.consentResult?.findResult() else {
                fatalError("Consent Document/Signature unexpectedly not found")
        }

        signatureResult.applyToDocument(consentDoc)

        consentDoc.makePDFWithCompletionHandler{ (pdfData, pdfError) in
            guard let pdfData = pdfData else {
                block(pdfError)
                return
            }

            consent.uploadConsentPDF(pdfData){ pdfUploadError in
                if let pdfUploadError = pdfUploadError {
                    block(pdfUploadError)
                    return
                }

                block(nil)
            }
        }
    }

    func login(email email: String, password: String) {
        CMHUser.currentUser().loginWithEmail(email, password: password) { error in
            if let error = error {
                "Error logging in".alert(in: self.presentedViewController, withError: error)
                return
            }

            guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                fatalError("Unexpected App Delegate Class")
            }

            appDelegate.loadMainPanel()
        }
    }
}

// MARK: Target-Action

extension OnboardingViewController {

    @IBAction func didPressJoin(sender: UIButton) {
        let (task, document) = Consent.TaskDocument
        self.consentDocument = document

        let consentVC = ORKTaskViewController(task: task, restorationData: nil, delegate: self)
        consentVC.view.tintColor = UIColor.acmBlue()

        presentViewController(consentVC, animated: true, completion: nil)
    }

    @IBAction func didPressLogin(sender: UIButton) {
        let loginVC = CMHAuthViewController.loginViewController()
        loginVC.delegate = self

        presentViewController(loginVC, animated: true, completion: nil)
    }
}

// MARK: ORKTaskViewControllerDelegate

extension OnboardingViewController: ORKTaskViewControllerDelegate {

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        guard presentedViewController == taskViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        guard case .Completed = reason else {
            return
        }

        consentResult = taskViewController.result
        let signupVC = CMHAuthViewController.signupViewController()
        signupVC.delegate = self
        presentViewController(signupVC, animated: true, completion: nil)
    }
}

// MARK: CMHAuthViewDelegate

extension OnboardingViewController: CMHAuthViewDelegate {

    func authViewOfType(authType: CMHAuthType, didSubmitWithEmail email: String, andPassword password: String) {
        switch authType {
        case .Signup:
            signup(email: email, password: password)
        case .Login:
            login(email: email, password: password)
        }
    }

    func authViewCancelledType(authType: CMHAuthType) {
        guard let _ = presentedViewController as? CMHAuthViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
}