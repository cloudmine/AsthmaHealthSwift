import UIKit

class ActivitiesViewController: UITableViewController {

    private let surveys = [ SurveyInfo(displayName: NSLocalizedString("About You", comment: ""),
                                            rkIdentifier: "ACMAboutYouSurveyTask",
                                            frequency: .Daily,
                                            questionCount: 8),

                            SurveyInfo(displayName: NSLocalizedString("Daily Survey", comment: ""),
                                            rkIdentifier: "ACMDailySurveyTask",
                                            frequency: .Weekly,
                                            questionCount: 8)
                          ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableViewDataSource

extension ActivitiesViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)

        guard let activityCell = cell as? ActivityCell where indexPath.row <= surveys.count else {
            return cell
        }

        activityCell.configure(withInfo: surveys[indexPath.row])

        return activityCell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72.0
    }
}

// MARK: UITableViewDelegate

extension ActivitiesViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Cell: \(indexPath.row)")
    }
}
