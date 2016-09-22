import UIKit

extension UIButton {

    func setBorder(width: CGFloat, cornerRadius radius: CGFloat) {
        layer.borderColor = titleLabel?.textColor?.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
}
