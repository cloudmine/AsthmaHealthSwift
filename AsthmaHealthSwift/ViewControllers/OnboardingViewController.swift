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

// MARK: Target-Action

extension OnboardingViewController {
    
    @IBAction func didPressJoin(_ sender: UIButton) {
        let consentVC = ORKTaskViewController(task: Consent.Task, restorationData: nil, delegate: self)
        consentVC.view.tintColor = UIColor.acmBlue()
        
        present(consentVC, animated: true, completion: nil)
    }
    
    @IBAction func didPressLogin(_ sender: UIButton) {
        let loginVC = CMHLoginViewController(title: NSLocalizedString("Log In", comment: ""),
                                             text: NSLocalizedString("lease log in to you account to store and access your research data.", comment: ""),
                                             delegate: self)
        loginVC.view.tintColor = UIColor.acmBlue()
        
        present(loginVC, animated: true, completion: nil)
    }
}

// MARK: CMHLoginViewControllerDelegate

extension OnboardingViewController: CMHLoginViewControllerDelegate {
    
    func loginViewControllerCancelled(_ viewController: CMHLoginViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func loginViewController(_ viewController: CMHLoginViewController, didLogin success: Bool, error: Error?) {
        if !success {
            alert(localizedMessage: NSLocalizedString("Something went wrong logging in", comment: ""),
                  inViewController: self.presentedViewController,
                  withError: error)
            return
        }
        viewController.view.endEditing(true)
        appDelegate.loadMainPanel()
    }
}


// MARK: ORKTaskViewControllerDelegate

extension OnboardingViewController: ORKTaskViewControllerDelegate {

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        guard presentedViewController == taskViewController else {
            return
        }

        guard case .completed = reason else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        CMHUser.current().signUp(withRegistration: taskViewController.result) { error in
            if let error = error {
                alert(localizedMessage: NSLocalizedString("Sign up Failed", comment: ""), inViewController: self.presentedViewController, withError: error)
                return
            }
            taskViewController.view.endEditing(true)
            self.appDelegate.loadMainPanel()
        }
    }
}
