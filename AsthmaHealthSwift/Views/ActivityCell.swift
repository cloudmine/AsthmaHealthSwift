import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet private weak var frequencyIndicator: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var questionCountLabel: UILabel!
    @IBOutlet private weak var completionImage: UIImageView!

    private let questionWord = NSLocalizedString("Questions", comment: "")

    func configure(withInfo info: SurveyInfo) {
        onMainThread {
            self.nameLabel.text = info.displayName
            self.questionCountLabel.text = "\(info.questionCount) \(self.questionWord)"
            self.frequencyIndicator.backgroundColor = ActivityCell.color(forFrequency: info.frequency)
        }
    }

    private static func color(forFrequency freq:SurveyFrequency) -> UIColor  {
        switch freq {
        case .OneTime:
            return UIColor.acmOneTime()
        case .Daily:
            return UIColor.acmDaily()
        }
    }
}
