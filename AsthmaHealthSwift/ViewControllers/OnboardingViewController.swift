import UIKit
import CMHealth

class OnboardingViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    fileprivate var consentResult: ORKTaskResult? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        joinButton.setBorder(width: 1.0, cornerRadius: 4.0)
        removeNavigationBarDropShadow()
    }
}

// MARK: Private
extension OnboardingViewController {

    fileprivate func signup(email: String, password: String) {
        CMHUser.current().signUp(withEmail: email, password: password) { signupError in
            if let signupError = signupError {
                alert(localizedMessage: NSLocalizedString("Error during signup", comment: ""), inViewController: self, withError: signupError)
                return
            }

            CMHUser.current().uploadUserConsent(self.consentResult, withCompletion: { (consent, uploadError) in
                guard let _ = consent else {
                    alert(localizedMessage: NSLocalizedString("Error during signup while uploading consent", comment: ""), inViewController: self, withError: uploadError)
                    return
                }

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    fatalError("Unexpected App Delegate Class")
                }

                appDelegate.loadMainPanel()
            })
        }
    }

    fileprivate func login(email: String, password: String) {
        CMHUser.current().login(withEmail: email, password: password) { error in
            if let error = error {
                alert(localizedMessage: NSLocalizedString("Error logging in", comment: ""), inViewController: self.presentedViewController, withError: error)
                return
            }

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Unexpected App Delegate Class")
            }

            appDelegate.loadMainPanel()
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
        let loginVC = CMHAuthViewController.login()
        loginVC.delegate = self

        present(loginVC, animated: true, completion: nil)
    }
}

// MARK: ORKTaskViewControllerDelegate

extension OnboardingViewController: ORKTaskViewControllerDelegate {

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        guard presentedViewController == taskViewController else {
            return
        }

        dismiss(animated: true, completion: nil)

        guard case .completed = reason else {
            return
        }

        consentResult = taskViewController.result
        let signupVC = CMHAuthViewController.signup()
        signupVC.delegate = self
        present(signupVC, animated: true, completion: nil)
    }
}

// MARK: CMHAuthViewDelegate

extension OnboardingViewController: CMHAuthViewDelegate {

    func authView(of authType: CMHAuthType, didSubmitWithEmail email: String, andPassword password: String) {
        switch authType {
        case .signup:
            signup(email: email, password: password)
        case .login:
            login(email: email, password: password)
        }
    }

    func authViewCancelledType(_ authType: CMHAuthType) {
        guard let _ = presentedViewController as? CMHAuthViewController else {
            return
        }

        dismiss(animated: true, completion: nil)
    }
}
