import UIKit

class LoadingOverlay: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(overView otherView: UIView) {
        super.init(frame: otherView.frame)

        backgroundColor = UIColor.blackColor()
        alpha = 0.2

        let indicatorFrame = CGRectMake(otherView.center.x - 37.0/2.0, otherView.center.y - 37.0/2.0, 37.0, 37.0)
        let indicator = UIActivityIndicatorView(frame: indicatorFrame)
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)

        self.hidden = true
        otherView.addSubview(self)
    }

    func show(loading shouldShow:Bool) {
        onMainThread {
            self.hidden = !shouldShow
        }
    }
}
