import UIKit
import CMHealth

typealias SurveyResults = (about: ORKTaskResult?, daily: [ORKTaskResult])

class MainPanelViewController: UITabBarController {

    private(set) var results: Observable<SurveyResults> = Observable((about: nil, daily: []))

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
}

// MARK: Networking

extension MainPanelViewController {

    func upload(result result: ORKTaskResult) {
        result.cmh_saveWithCompletion { (status, error) in
            guard let _ = status else {
                "Failed to submit survey results".alert(in: self, withError: error)
                return
            }

            print("Upload Successful")
        }
    }

    func refresh() {
        ORKTaskResult.cmh_fetchUserResultsForStudyWithIdentifier(Survey.Daily.info.rkIdentifier) { (fetchResults, error) in
            guard let fetchResults = fetchResults as? [ORKTaskResult] else {
                "Error fetching past results".alert(in: self, withError: error)
                return
            }

            self.results <- (about: self.results.value.about, daily: fetchResults)

            print("Fetched: \(self.results)")
        }
    }
}
