
final class Observable<T> {
    typealias Observer = AnyObject
    typealias ObservableBlock = (newValue: T) -> ()
    typealias ObservablePair = (observer: Observer, block: ObservableBlock)

    // MARK: Public Interface

    var value: T { didSet {
            observers.forEach { (_, block) in block(newValue: value) }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func add(observer observer: Observer, block: ObservableBlock) {
        guard !has(observer: observer) else {
            return
        }

        observers.append((observer, block))
    }

    func remove(observer observer: Observer) {
        observers = observers.filter { (obs, _) in obs !== observer }
    }

    // MARK: Private

    private var observers: [ObservablePair] = []

    private func has(observer observer: Observer) -> Bool {
        return observers.reduce(false) { (acc, pair) in acc || pair.observer === observer }
    }
}

infix operator <- { associativity right precedence 90 }

func <-<T>(lhs: Observable<T>, rhs: T) {
    lhs.value = rhs
}