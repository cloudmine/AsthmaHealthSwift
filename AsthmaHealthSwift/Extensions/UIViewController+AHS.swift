import UIKit

extension UIViewController {

    var mainPanel: MainPanelViewController? {
        return findParent(ofViewController: self)
    }

    func removeNavigationBarDropShadow() {
        let navController: UINavigationController? = findParent(ofViewController: self)

        navController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navController?.navigationBar.shadowImage = UIImage()
    }
}

// Find the first ViewController of a given anywhere in the hiearchy of a base ViewController
private func findParent<V: UIViewController>(ofViewController viewController: UIViewController?) -> V? {
    if let typedViewController = viewController as? V {
        return typedViewController
    }

    guard let parentViewController = viewController?.parentViewController else {
        return nil
    }

    return findParent(ofViewController: parentViewController)
}
