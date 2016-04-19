import UIKit
import ResearchKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var onceChart: ORKPieChartView!
    @IBOutlet weak var dailyChart: ORKPieChartView!

    private var hasCompletedAbout = false

    override func viewDidLoad() {
        super.viewDidLoad()

        onceChart.title = NSLocalizedString("One Time Surveys", comment: "")
        dailyChart.title = NSLocalizedString("Daily Surveys (Today)", comment: "")
        
        [onceChart, dailyChart].forEach { chart in
            chart.showsTitleAboveChart = true
            chart.dataSource = self
        }
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
}
