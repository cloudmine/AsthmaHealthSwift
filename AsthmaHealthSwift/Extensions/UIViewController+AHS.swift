import UIKit

extension UIViewController {

    func removeNavigationBarDropShadow() {
        var viewController: UIViewController? = self

        while nil != viewController {
            guard let navController = viewController as? UINavigationController else {
                viewController = viewController?.parentViewController
                continue
            }

            navController.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
            navController.navigationBar.shadowImage = UIImage()
            break
        }
    }
}
