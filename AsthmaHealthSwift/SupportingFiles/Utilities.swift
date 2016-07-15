import UIKit

func onMainThread(_ block: ()->()) {
    if OperationQueue.current == OperationQueue.main {
        block()
        return
    }

    DispatchQueue.main.async {
        block()
    }
}

func alert(localizedMessage message: String, inViewController viewController: UIViewController?, withError error: NSError? = nil) {
    var message = message
    
    if let errorMessage = error?.localizedDescription {
        message = "\(message); \(errorMessage)"
    }

    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
    alert.addAction(okAction)

    guard let viewController = viewController else {
        print(message)
        return
    }

    onMainThread {
        viewController.present(alert, animated: true, completion: nil)
    }
}
