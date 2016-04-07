import UIKit
import CMHealth

class OnboardingViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    private var consentResult: ORKTaskResult? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        joinButton.setBorder(width: 1.0, corderRadius: 4.0)
        removeNavigationBarDropShadow()
    }
}

// MARK: Private
extension OnboardingViewController {

    private func signup(email email: String, password: String) {
        CMHUser.currentUser().signUpWithEmail(email, password: password) { signupError in
            if let signupError = signupError {
                print(signupError.localizedDescription) // TODO: Real error handling
                return
            }

            print("Signup Successfull")

            CMHUser.currentUser().uploadUserConsent(self.consentResult, withCompletion: { (consent, uploadError) in
                guard let _ = consent else {
                    print("Error uploading consent: \(uploadError?.localizedDescription)")
                    return
                }

                print("Consent Upload Successful")
            })
        }
    }
}

// MARK: Target-Action

extension OnboardingViewController {

    @IBAction func didPressJoin(sender: UIButton) {
        let consentVC = ORKTaskViewController(task: Consent.Task, restorationData: nil, delegate: self)
        consentVC.view.tintColor = UIColor.acmBlueColor()

        presentViewController(consentVC, animated: true, completion: nil)
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
            break
        }
    }

    func authViewCancelledType(authType: CMHAuthType) {
        guard let _ = presentedViewController as? CMHAuthViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
}