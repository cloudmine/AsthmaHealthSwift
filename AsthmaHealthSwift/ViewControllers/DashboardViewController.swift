import UIKit
import ResearchKit

class DashboardViewController: UIViewController, Observer {

    @IBOutlet weak var aboutChart: ORKPieChartView!
    @IBOutlet weak var dailyChart: ORKPieChartView!

    fileprivate var hasCompletedAbout = false
    fileprivate var hasCompletedDaily = false

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutChart.title = NSLocalizedString("About Your Survey", comment: "")
        dailyChart.title = NSLocalizedString("Daily Surveys (Today)", comment: "")

        [aboutChart, dailyChart].forEach { chart in
            chart?.showsTitleAboveChart = true
            chart?.dataSource = self
        }

        self.refreshUI(withResults: mainPanel?.results&)

        observe(mainPanel?.results) { (newResults) in
            self.refreshUI(withResults: newResults)
        }
    }

    deinit {
        stopObserving(mainPanel?.results)
    }
}

// MARK: Target-Action

private extension DashboardViewController {

    @IBAction func refreshDidPress(_ sender: UIButton) {
        mainPanel?.refresh()
    }
}

// MARK: ORKPieChartViewDataSource

extension DashboardViewController: ORKPieChartViewDataSource {

    func numberOfSegments(in pieChartView: ORKPieChartView) -> Int {
        return 1
    }

    func pieChartView(_ pieChartView: ORKPieChartView, valueForSegmentAt index: Int) -> CGFloat {
        return 1.0
    }

    func pieChartView(_ pieChartView: ORKPieChartView, titleForSegmentAt index: Int) -> String {
        if pieChartView == aboutChart && hasCompletedAbout
            || pieChartView == dailyChart && hasCompletedDaily {

            return NSLocalizedString("Complete", comment: "")
        }

        return NSLocalizedString("Incomplete", comment: "")
    }

    func pieChartView(_ pieChartView: ORKPieChartView, colorForSegmentAt index: Int) -> UIColor {
        if pieChartView == aboutChart && hasCompletedAbout {
            return UIColor.acmOneTime()
        } else if pieChartView == dailyChart && hasCompletedDaily {
            return UIColor.acmDaily()
        }

        return UIColor.red
    }
}

// MARK: Private

private extension DashboardViewController {

    func refreshUI(withResults results: SurveyResults?) {
        guard let results = results else {
            return
        }

        hasCompletedAbout = nil != results.about
        hasCompletedDaily = results.daily.anyCompletedToday

        onMainThread {
            self.aboutChart.dataSource = self
            self.dailyChart.dataSource = self
        }
    }
}
