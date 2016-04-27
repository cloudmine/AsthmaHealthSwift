import UIKit

func onMainThread(block: ()->()) {
    if NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue() {
        block()
        return
    }

    dispatch_async(dispatch_get_main_queue()) {
        block()
    }
}

func alert(localizedMessage message: String, inViewController viewController: UIViewController?, withError error: NSError? = nil) {
    var message = message
    
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