import UIKit

class ShowPDFViewController: UIViewController {

    @IBOutlet private weak var webView: UIWebView!
    private var pdfData: NSData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let pdfData = pdfData else {
            return
        }

        if let baseURL = NSURL(string: "http://cloudmineinc.com") {
            webView?.loadData(pdfData, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: baseURL)
        }
    }

    @IBAction private func doneButtonDidPress(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Public Factory Method

extension ShowPDFViewController {

    static func showing(pdf pdfData:NSData) -> ShowPDFViewController? {
        let viewController = UIStoryboard(name: "ShowPDF", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? ShowPDFViewController
        viewController?.pdfData = pdfData

        return viewController
    }
}
