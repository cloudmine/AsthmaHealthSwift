import UIKit
import CMHealth

class OnboardingViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    private var consentResult: ORKTaskResult? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        joinButton.setBorder(width: 1.0, cornerRadius: 4.0)
        removeNavigationBarDropShadow()
    }
}

// MARK: Private
extension OnboardingViewController {

    private func signup(email email: String, password: String) {
        CMHUser.currentUser().signUpWithEmail(email, password: password) { signupError in
            if let signupError = signupError {
                alert(localizedMessage: NSLocalizedString("Error during signup", comment: ""), inViewController: self, withError: signupError)
                return
            }

            CMHUser.currentUser().uploadUserConsent(self.consentResult, withCompletion: { (consent, uploadError) in
                guard let _ = consent else {
                    alert(localizedMessage: NSLocalizedString("Error during signup while uploading consent", comment: ""), inViewController: self, withError: uploadError)
                    return
                }

                guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                    fatalError("Unexpected App Delegate Class")
                }

                appDelegate.loadMainPanel()
            })
        }
    }

    private func login(email email: String, password: String) {
        CMHUser.currentUser().loginWithEmail(email, password: password) { error in
            if let error = error {
                alert(localizedMessage: NSLocalizedString("Error logging in", comment: ""), inViewController: self.presentedViewController, withError: error)
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
        let consentVC = ORKTaskViewController(task: Consent.Task, restorationData: nil, delegate: self)
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
