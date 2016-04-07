import UIKit
import CMHealth

class OnboardingViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        joinButton.setBorder(width: 1.0, corderRadius: 4.0)
        removeNavigationBarDropShadow()
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
        guard let _ = presentedViewController as? ORKTaskViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        guard case .Completed = reason else {
            return
        }

        let signupVC = CMHAuthViewController.signupViewController()
        signupVC.delegate = self
        presentViewController(signupVC, animated: true, completion: nil)
    }
}

// MARK: CMHAuthViewDelegate

extension OnboardingViewController: CMHAuthViewDelegate {
    func authViewOfType(authType: CMHAuthType, didSubmitWithEmail email: String, andPassword password: String) {

    }

    func authViewCancelledType(authType: CMHAuthType) {
        guard let _ = presentedViewController as? CMHAuthViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
}