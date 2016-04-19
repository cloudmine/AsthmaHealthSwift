import UIKit
import ResearchKit

class ActivitiesViewController: UITableViewController {

    private let surveys = [Survey.About.info, Survey.Daily.info]

    override func viewDidLoad() {
        super.viewDidLoad()

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        tableView.addSubview(refresher)

        mainPanel?.results.add(observer: self) { _ in
            onMainThread {
                self.tableView.reloadData()
            }
        }
    }

    deinit {
        mainPanel?.results.remove(observer: self)
    }
}

// MARK: Target-Action

extension ActivitiesViewController {

    func refresh(control: UIRefreshControl) {
        mainPanel?.refresh()
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

        let info = surveys[indexPath.row]
        activityCell.configure(withInfo: info, asCompleted: hasCompleted(surveyWithInfo: info))

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

        let surveyVC = ORKTaskViewController(task: task, restorationData: nil, delegate: self)
        presentViewController(surveyVC, animated: true, completion: nil)
    }
}

// MARK: ORKTaskViewControllerDelegate

extension ActivitiesViewController: ORKTaskViewControllerDelegate {

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        guard presentedViewController == taskViewController else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        guard nil == error else {
            "Error completing survey".alert(in: self, withError: error)
            return
        }

        guard case .Completed = reason else {
            return
        }

        mainPanel?.upload(result: taskViewController.result)
    }
}

// MARK: Private

private extension ActivitiesViewController {

    func hasCompleted(surveyWithInfo info: SurveyInfo) -> Bool {
        switch info.frequency {
        case .OneTime:
            return hasCompletedAboutYou()
        case .Daily:
            return hasCompletedDailyToday()
        }
    }

    func hasCompletedDailyToday() -> Bool {
        guard let dailyResults = mainPanel?.results.value.daily else {
            return false
        }

        return dailyResults.reduce(false) { (acc, taskResult) in
            guard let isToday = taskResult.endDate?.isToday else {
                return acc || false
            }

            return acc || isToday
        }
    }

    func hasCompletedAboutYou() -> Bool {
        return nil != mainPanel?.results.value.about
    }
}
