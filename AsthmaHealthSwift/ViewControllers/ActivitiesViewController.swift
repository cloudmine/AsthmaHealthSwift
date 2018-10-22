import UIKit
import ResearchKit

class ActivitiesViewController: UITableViewController, Observer {

    fileprivate let surveys = [Survey.About.info, Survey.Daily.info]

    override func viewDidLoad() {
        super.viewDidLoad()

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refresher)

        observe(mainPanel?.results) { _ in
            onMainThread {
                self.tableView.reloadData()
            }
        }
    }

    deinit {
        stopObserving(mainPanel?.results)
    }
}

// MARK: Target-Action

extension ActivitiesViewController {

    @objc func refresh(_ control: UIRefreshControl) {
        mainPanel?.refresh()
        control.endRefreshing()
    }
}

// MARK: UITableViewDataSource

extension ActivitiesViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)

        guard let activityCell = cell as? ActivityCell, indexPath.row <= surveys.count else {
            return cell
        }

        let info = surveys[indexPath.row]
        activityCell.configure(withInfo: info, asCompleted: hasCompleted(surveyWithInfo: info))

        return activityCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}

// MARK: UITableViewDelegate

extension ActivitiesViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <= surveys.count,
            let task = Survey.task(forInfo: surveys[indexPath.row]) else {
            return
        }

        let surveyVC = ORKTaskViewController(task: task, restorationData: nil, delegate: self)
        present(surveyVC, animated: true, completion: nil)
    }
}

// MARK: ORKTaskViewControllerDelegate

extension ActivitiesViewController: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        guard presentedViewController == taskViewController else {
            return
        }

        dismiss(animated: true, completion: nil)

        guard nil == error else {
            alert(localizedMessage: NSLocalizedString( "Error completing survey", comment: ""), inViewController: self, withError: error)
            return
        }

        guard case .completed = reason else {
            return
        }

        mainPanel?.upload(result: taskViewController.result)
    }
}

// MARK: Private

private extension ActivitiesViewController {

    func hasCompleted(surveyWithInfo info: SurveyInfo) -> Bool {
        switch info.frequency {
        case .oneTime:
            return hasCompletedAboutYou()
        case .daily:
            return hasCompletedDailyToday()
        }
    }

    func hasCompletedDailyToday() -> Bool {
        guard let dailyResults = mainPanel?.results.value.daily else {
            return false
        }

        return dailyResults.anyCompletedToday
    }

    func hasCompletedAboutYou() -> Bool {
        return nil != mainPanel?.results.value.about
    }
}
