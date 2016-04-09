import UIKit

extension String {

    func alert(in viewController: UIViewController?, withError error: NSError? = nil) {

        var message = NSLocalizedString(self, comment: "")
        if let errorMessage = error?.localizedDescription {
            message = "\(message); \(errorMessage)"
        }

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil)
        alert.addAction(okAction)

        guard let viewController = viewController else {
            print(message)
            return
        }

        onMainThread {
            viewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
}