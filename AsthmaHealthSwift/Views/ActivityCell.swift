import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet private weak var frequencyIndicator: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var questionCountLabel: UILabel!
    @IBOutlet private weak var completionImage: UIImageView!

    private static let QuestionWord = NSLocalizedString("Questions", comment: "")

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)

        completionImage.layer.borderWidth = 1.0;
        completionImage.layer.cornerRadius = self.completionImage.bounds.size.height / 2.0;
    }

    func configure(withInfo info: SurveyInfo, asCompleted isCompleted: Bool) {
        nameLabel.text = info.displayName
        questionCountLabel.text = "\(info.questionCount) \(ActivityCell.QuestionWord)"
        frequencyIndicator.backgroundColor = ActivityCell.color(forFrequency: info.frequency)

        userInteractionEnabled = !isCompleted

        if isCompleted {
            completionImage.layer.borderColor = UIColor.clearColor().CGColor
            completionImage.image = UIImage(named: "CheckMark")
        } else {
            completionImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            completionImage.image = nil
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
