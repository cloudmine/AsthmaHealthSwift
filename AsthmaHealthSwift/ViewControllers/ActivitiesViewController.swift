import UIKit
import ResearchKit

class ActivitiesViewController: UITableViewController {

    private let surveys = [ SurveyInfo(displayName: NSLocalizedString("About You", comment: ""),
                                            rkIdentifier: "ACMAboutYouSurveyTask",
                                            frequency: .Daily,
                                            questionCount: 8),

                            Survey.Daily.info
                          ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        tableView.addSubview(refresher)
    }
}

// MARK: Target-Action

extension ActivitiesViewController {

    func refresh(control: UIRefreshControl) {
        control.endRefreshing()
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
        guard indexPath.row <= surveys.count,
            let task = Survey.task(forInfo: surveys[indexPath.row]) else {
            return
        }

        let surveyVC = ORKTaskViewController(task: task, restorationData: nil, delegate: nil)
        presentViewController(surveyVC, animated: true, completion: nil)
    }
}
