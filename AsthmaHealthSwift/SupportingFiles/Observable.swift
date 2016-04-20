
protocol Observer: Equatable {}

extension Observer {
    func observe<T>(observable: Observable<T>, block: (newValue: T) -> ()) {
        guard  !observable.has(observer: self) else {
            return
        }

        observable.observers.append((self, block))
    }

    func stopObserving<T>(observable: Observable<T>) {
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
            observers.forEach { (_, block) in block(newValue: value) }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    // MARK: Private

    private typealias ObservableBlock = (newValue: T) -> ()
    private typealias ObservablePair = (observer: Any, block: ObservableBlock)
    private var observers: [ObservablePair] = []

    private func has<U:Observer>(observer observer: U) -> Bool {
        for (obs, _) in observers {
            if let obs = obs as? U where obs == observer {
                return true
            }
        }

        return false
    }
}

infix operator <- { associativity right precedence 90 }

func <-<T>(lhs: Observable<T>, rhs: T) {
    lhs.value = rhs
}
