import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet private weak var frequencyIndicator: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var questionCountLabel: UILabel!
    @IBOutlet private weak var completionImage: UIImageView!

    private static let QuestionWord = NSLocalizedString("Questions", comment: "")

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        completionImage.layer.borderWidth = 1.0;
        completionImage.layer.cornerRadius = self.completionImage.bounds.size.height / 2.0;
    }

    func configure(withInfo info: SurveyInfo, asCompleted isCompleted: Bool) {
        nameLabel.text = info.displayName
        questionCountLabel.text = "\(info.questionCount) \(ActivityCell.QuestionWord)"
        frequencyIndicator.backgroundColor = ActivityCell.color(forFrequency: info.frequency)

        isUserInteractionEnabled = !isCompleted

        if isCompleted {
            completionImage.layer.borderColor = UIColor.clear.cgColor
            completionImage.image = UIImage(named: "CheckMark")
        } else {
            completionImage.layer.borderColor = UIColor.lightGray.cgColor
            completionImage.image = nil
        }
    }

    private static func color(forFrequency freq:SurveyFrequency) -> UIColor  {
        switch freq {
        case .oneTime:
            return UIColor.acmOneTime()
        case .daily:
            return UIColor.acmDaily()
        }
    }
}
