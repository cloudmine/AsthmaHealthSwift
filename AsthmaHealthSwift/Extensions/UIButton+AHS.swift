import UIKit

extension UIButton {

    func setBorder(width width: CGFloat, cornerRadius radius: CGFloat) {
        layer.borderColor = titleLabel?.textColor?.CGColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
}
