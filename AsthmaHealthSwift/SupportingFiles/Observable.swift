
protocol Observer: Equatable {}

extension Observer {
    func observe<T>(_ observable: Observable<T>?, block: @escaping (_ newValue: T) -> ()) {
        guard let observable = observable , !observable.has(observer: self) else {
            return
        }

        observable.observers.append((self, block))
    }

    func stopObserving<T>(_ observable: Observable<T>?) {
        guard let observable = observable else {
            return
        }
        
        observable.observers = observable.observers.filter { (obs, _) in
            guard let obs = obs as? Self else {
                return true
            }

            return obs != self
        }
    }
}

final class Observable<T> {

    // MARK: Public Interface

    var value: T { didSet {
        observers.forEach { (observer) in
            observer.block(value) }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    // MARK: Private

    fileprivate typealias ObservableBlock = (_ newValue: T) -> ()
    fileprivate typealias ObservablePair = (observer: Any, block: ObservableBlock)
    fileprivate var observers: [ObservablePair] = []

    fileprivate func has<U:Observer>(observer: U) -> Bool {
        for (obs, _) in observers {
            if let obs = obs as? U , obs == observer {
                return true
            }
        }

        return false
    }
}

infix operator <- : AssignmentPrecedence

func <-<T>(lhs: Observable<T>, rhs: T) {
    lhs.value = rhs
}

postfix operator &

postfix func &<T>(obs: Observable<T>?) -> T? {
    return obs?.value
}
