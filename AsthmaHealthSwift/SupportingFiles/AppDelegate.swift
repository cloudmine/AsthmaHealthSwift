import UIKit
import CMHealth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CMHealth.setAppIdentifier(Secrets.AppId, appSecret: Secrets.APIKey)

        if CMHUser.currentUser().isLoggedIn {
            print("Logged in as \(CMHUser.currentUser())")
            loadMainPanel()
        } else {
            loadOnboarding()
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {

    }

    func loadOnboarding() {
        load(storyboard: "Onboarding")
    }

    func loadMainPanel() {
        load(storyboard: "MainPanel")
    }

    private func load(storyboard name: String) {
        onMainThread { 
            let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
    }
}

