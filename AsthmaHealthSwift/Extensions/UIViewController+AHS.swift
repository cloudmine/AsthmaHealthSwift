import UIKit

extension UIViewController {

    var mainPanel: MainPanelViewController? {
        return findMainPanel(self)
    }

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

private func findMainPanel(viewController: UIViewController?) -> MainPanelViewController? {
    if let mainPanel = viewController as? MainPanelViewController {
        return mainPanel
    }

    guard let parentViewController = viewController?.parentViewController else {
        return nil
    }

    return findMainPanel(parentViewController)
}
