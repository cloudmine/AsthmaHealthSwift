import UIKit
import CMHealth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.main().bounds)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CMHealth.setAppIdentifier(Secrets.AppId, appSecret: Secrets.APIKey)

        if CMHUser.current().isLoggedIn {
            print("Logged in as \(CMHUser.current())")
            loadMainPanel()
        } else {
            loadOnboarding()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

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

