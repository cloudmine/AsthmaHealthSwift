import UIKit
import ResearchKit

class DashboardViewController: UIViewController {

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

        self.refreshUI(withResults: mainPanel?.results.value)

        mainPanel?.results.add(observer: self) { (newResults) in
            self.refreshUI(withResults: newResults)
        }
    }

    deinit {
        mainPanel?.results.remove(observer: self)
    }
}

// MARK: Target-Action

private extension DashboardViewController {

    @IBAction func refreshDidPress(sender: UIButton) {
        mainPanel?.refresh()
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