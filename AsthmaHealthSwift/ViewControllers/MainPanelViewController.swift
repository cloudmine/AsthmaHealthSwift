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

    func upload(result: ORKTaskResult) {
        loadingOverlay?.show(loading: true)

        result.cmh_save { (status, error) in
            self.loadingOverlay?.show(loading: false)
            
            guard let _ = status else {
                alert(localizedMessage: NSLocalizedString( "Failed to submit survey results", comment: ""), inViewController: self, withError: error)
                return
            }

            self.refresh()
        }
    }

    func refresh() {
        loadingOverlay?.show(loading: true)

        ORKTaskResult.cmh_fetchUserResultsForStudy(withIdentifier: Survey.Daily.info.rkIdentifier) { (dailyResults, dailyError) in
            guard let dailyResults = dailyResults as? [ORKTaskResult] else {
                self.loadingOverlay?.show(loading: false)
                alert(localizedMessage: NSLocalizedString("Error fetching past daily results", comment: ""), inViewController: self, withError: dailyError)
                return
            }

            ORKTaskResult.cmh_fetchUserResultsForStudy(withIdentifier: Survey.About.info.rkIdentifier) { (aboutResults, aboutError) in
                self.loadingOverlay?.show(loading: false)

                guard let aboutResults = aboutResults as? [ORKTaskResult] else {
                    alert(localizedMessage: NSLocalizedString("Error fetching about results", comment: ""), inViewController: self, withError: aboutError)
                    return
                }

                self.results <- (about: aboutResults.first, daily: dailyResults)
            }
        }
    }
}
