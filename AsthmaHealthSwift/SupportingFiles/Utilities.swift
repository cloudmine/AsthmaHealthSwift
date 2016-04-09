import Foundation

func onMainThread(block: ()->()) {
    if NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue() {
        block()
        return
    }

    dispatch_async(dispatch_get_main_queue()) {
        block()
    }
}
