import UIKit

func onMainThread(_ block: @escaping ()->()) {
    if OperationQueue.current == OperationQueue.main {
        block()
        return
    }
    
    DispatchQueue.main.async {
        block()
    }
}

func alert(localizedMessage message: String, inViewController viewController: UIViewController?, withError error: Error? = nil) {
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
        
        if viewController.view.window != nil {
            viewController.present(alert, animated: true, completion: nil)
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
        
    }
}
