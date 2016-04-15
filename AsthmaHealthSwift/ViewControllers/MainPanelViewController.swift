import UIKit
import CMHealth

class MainPanelViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Public Networking

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
}
