import UIKit
import ResearchKit

class DashboardViewController: UIViewController, Observer {

    @IBOutlet weak var aboutChart: ORKPieChartView!
    @IBOutlet weak var dailyChart: ORKPieChartView!

    private var hasCompletedAbout = false
    private var hasCompletedDaily = false

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutChart.title = NSLocalizedString("About Your Survey", comment: "")
        dailyChart.title = NSLocalizedString("Daily Surveys (Today)", comment: "")

        [aboutChart, dailyChart].forEach { chart in
            chart.showsTitleAboveChart = true
            chart.dataSource = self
        }

        guard let mainPanel = mainPanel else {
            return
        }

        self.refreshUI(withResults: mainPanel.results&)

        observe(mainPanel.results) { (newResults) in
            self.refreshUI(withResults: newResults)
        }
    }

    deinit {
        guard let mainPanel = mainPanel else {
            return
        }

        stopObserving(mainPanel.results)
    }
}

// MARK: Target-Action

private extension DashboardViewController {

    @IBAction func refreshDidPress(sender: UIButton) {
        //mainPanel?.refresh()
        guard let results = mainPanel?.results else {
            return
        }

        stopObserving(results)
    }
}

// MARK: ORKPieChartViewDataSource

extension DashboardViewController: ORKPieChartViewDataSource {

    func numberOfSegmentsInPieChartView(pieChartView: ORKPieChartView) -> Int {
        return 1
    }

    func pieChartView(pieChartView: ORKPieChartView, valueForSegmentAtIndex index: Int) -> CGFloat {
        return 1.0
    }

    func pieChartView(pieChartView: ORKPieChartView, titleForSegmentAtIndex index: Int) -> String {
        if pieChartView == aboutChart && hasCompletedAbout
            || pieChartView == dailyChart && hasCompletedDaily {

            return NSLocalizedString("Complete", comment: "")
        }

        return NSLocalizedString("Incomplete", comment: "")
    }

    func pieChartView(pieChartView: ORKPieChartView, colorForSegmentAtIndex index: Int) -> UIColor {
        if pieChartView == aboutChart && hasCompletedAbout {
            return UIColor.acmOneTime()
        } else if pieChartView == dailyChart && hasCompletedDaily {
            return UIColor.acmDaily()
        }

        return UIColor.redColor()
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