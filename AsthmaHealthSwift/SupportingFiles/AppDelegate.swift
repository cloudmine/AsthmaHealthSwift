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
            load(storyboard: "MainPanel")
        } else {
            load(storyboard: "Onboarding")
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

    func load(storyboard name: String) {
        let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

