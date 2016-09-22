import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet fileprivate weak var frequencyIndicator: UIView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var questionCountLabel: UILabel!
    @IBOutlet fileprivate weak var completionImage: UIImageView!

    fileprivate static let QuestionWord = NSLocalizedString("Questions", comment: "")

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

    fileprivate static func color(forFrequency freq:SurveyFrequency) -> UIColor  {
        switch freq {
        case .oneTime:
            return UIColor.acmOneTime()
        case .daily:
            return UIColor.acmDaily()
        }
    }
}
