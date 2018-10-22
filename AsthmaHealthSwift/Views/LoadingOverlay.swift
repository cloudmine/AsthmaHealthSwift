import UIKit

class LoadingOverlay: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(overView otherView: UIView) {
        super.init(frame: otherView.frame)

        backgroundColor = UIColor.black
        alpha = 0.2
        
        let indicatorFrame = CGRect(x: otherView.center.x - 37.0/2.0, y: otherView.center.y - 37.0/2.0, width: 37.0, height: 37.0)
        let indicator = UIActivityIndicatorView(frame: indicatorFrame)
        indicator.style = .whiteLarge
        indicator.startAnimating()
        addSubview(indicator)

        self.isHidden = true
        otherView.addSubview(self)
    }

    func show(loading shouldShow:Bool) {
        onMainThread {
            self.isHidden = !shouldShow
        }
    }
}
