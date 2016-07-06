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
}

// MARK: Target-Action

extension OnboardingViewController {

    @IBAction func didPressJoin(sender: UIButton) {
        let consentVC = ORKTaskViewController(task: Consent.Task, restorationData: nil, delegate: self)
        consentVC.view.tintColor = UIColor.acmBlue()

        presentViewController(consentVC, animated: true, completion: nil)
    }

    @IBAction func didPressLogin(sender: UIButton) {
        let loginVC = CMHLoginViewController(title: NSLocalizedString("Login", comment: ""),
                                             text: NSLocalizedString("Please log in to you account to store and access your research data.", comment: ""),
                                             delegate: self)

        loginVC.view.tintColor = UIColor.acmBlue()

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

        let onboardingResult = taskViewController.result
        print(onboardingResult)
        // TODO: sign up with results
    }
}

// MARK: CMHLoginViewControllerDelegate

extension OnboardingViewController: CMHLoginViewControllerDelegate {

    func loginViewControllerCancelled(viewController: CMHLoginViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loginViewController(viewController: CMHLoginViewController, didLogin success: Bool, error: NSError?) {
        guard success else {
            alert(localizedMessage: NSLocalizedString("Sign In Failure", comment:""), inViewController: viewController, withError: error)
            return
        }

        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("Unexpected App Delegate Class")
        }

        appDelegate.loadMainPanel()
    }
}
