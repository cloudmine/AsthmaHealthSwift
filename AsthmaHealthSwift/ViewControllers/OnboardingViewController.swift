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

    private func signup(onboardingResult result: ORKTaskResult) {
        CMHUser.current().signUp(withRegistration: result) { signupError in
            guard nil == signupError else {
                alert(localizedMessage: NSLocalizedString("Error during signup", comment: ""), inViewController: self, withError: signupError)
                return
            }

            CMHUser.current().uploadUserConsent(result) { consent, uploadError in
                guard let _ = consent else {
                    alert(localizedMessage: NSLocalizedString("Error during signup while uploading consent", comment: ""), inViewController: self, withError: uploadError)
                    return
                }

                guard let appDelegate = UIApplication.shared().delegate as? AppDelegate else {
                    fatalError("Unexpected App Delegate Class")
                }

                appDelegate.loadMainPanel()
            }
        }
    }
}

// MARK: Target-Action

extension OnboardingViewController {

    @IBAction func didPressJoin(_ sender: UIButton) {
        let consentVC = ORKTaskViewController(task: Consent.Task, restorationData: nil, delegate: self)
        consentVC.view.tintColor = UIColor.acmBlue()

        present(consentVC, animated: true, completion: nil)
    }

    @IBAction func didPressLogin(_ sender: UIButton) {
        let loginVC = CMHLoginViewController(title: NSLocalizedString("Login", comment: ""),
                                             text: NSLocalizedString("Please log in to you account to store and access your research data.", comment: ""),
                                             delegate: self)

        loginVC.view.tintColor = UIColor.acmBlue()

        present(loginVC, animated: true, completion: nil)
    }
}

// MARK: ORKTaskViewControllerDelegate

extension OnboardingViewController: ORKTaskViewControllerDelegate {

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        guard presentedViewController == taskViewController else {
            return
        }

        dismiss(animated: true, completion: nil)

        guard case .completed = reason else {
            return
        }

        signup(onboardingResult: taskViewController.result)
    }
}

// MARK: CMHLoginViewControllerDelegate

extension OnboardingViewController: CMHLoginViewControllerDelegate {

    func loginViewControllerCancelled(_ viewController: CMHLoginViewController) {
        dismiss(animated: true, completion: nil)
    }

    func loginViewController(_ viewController: CMHLoginViewController, didLogin success: Bool, error: NSError?) {
        guard success else {
            alert(localizedMessage: NSLocalizedString("Sign In Failure", comment:""), inViewController: viewController, withError: error)
            return
        }

        guard let appDelegate = UIApplication.shared().delegate as? AppDelegate else {
            fatalError("Unexpected App Delegate Class")
        }

        appDelegate.loadMainPanel()
    }
}
