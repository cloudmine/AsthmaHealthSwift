import UIKit
import CMHealth

typealias SurveyResults = (about: ORKTaskResult?, daily: [ORKTaskResult])

class MainPanelViewController: UITabBarController {

    private(set) var results: Observable<SurveyResults> = Observable((about: nil, daily: []))
    private var loadingOverlay: LoadingOverlay? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingOverlay = LoadingOverlay(overView: self.view)
        refresh()
    }
}

// MARK: Networking

extension MainPanelViewController {

    func upload(result result: ORKTaskResult) {
        loadingOverlay?.show(loading: true)

        result.cmh_saveWithCompletion { (status, error) in
            self.loadingOverlay?.show(loading: false)
            
            guard let _ = status else {
                "Failed to submit survey results".alert(in: self, withError: error)
                return
            }

            self.refresh()
        }
    }

    func refresh() {
        loadingOverlay?.show(loading: true)

        ORKTaskResult.cmh_fetchUserResultsForStudyWithIdentifier(Survey.Daily.info.rkIdentifier) { (dailyResults, dailyError) in
            guard let dailyResults = dailyResults as? [ORKTaskResult] else {
                self.loadingOverlay?.show(loading: false)
                "Error fetching past daily results".alert(in: self, withError: dailyError)
                return
            }

            ORKTaskResult.cmh_fetchUserResultsForStudyWithIdentifier(Survey.About.info.rkIdentifier) { (aboutResults, aboutError) in
                self.loadingOverlay?.show(loading: false)

                guard let aboutResults = aboutResults as? [ORKTaskResult] else {
                    "Error fetching about results".alert(in: self, withError: aboutError)
                    return
                }

                self.results <- (about: aboutResults.first, daily: dailyResults)
            }
        }
    }
}
