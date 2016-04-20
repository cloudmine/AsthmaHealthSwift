
/*
 *  Observer: Given type, can observer an observable, can tell you if it's equivalent to Observer of same type
 *
 */

func add<T>(observer observer:Any, observable: Observable<T>, block: (newValue: T) -> ()) {
    observable.observers.append((observer, block))
}

//func remove<U:AnyObject,T>(observer observer:U, observable: Observable<T>) {
//    observable.observers = observable.observers.filter { (obs, _) in
//        guard let obs = obs as? U else {
//            return true
//        }
//
//        return obs !== observer
//    }
//}

func remove<U:Equatable,T>(observer observer:U, observable: Observable<T>) {
    observable.observers = observable.observers.filter { (obs, _) in
        guard let obs = obs as? U else {
            return true
        }

        return obs != observer
    }
}

final class Observable<T> {
    //typealias Observer = Any
    typealias ObservableBlock = (newValue: T) -> ()
    typealias ObservablePair = (observer: Any, block: ObservableBlock)

    // MARK: Public Interface

    var value: T { didSet {
            observers.forEach { (_, block) in block(newValue: value) }
        }
    }

    init(_ value: T) {
        self.value = value
    }

//    func add(observer observer: Observer, block: ObservableBlock) {
//        guard !has(observer: observer) else {
//            return
//        }
//
//        observers.append((observer, block))
//    }
//
//    func remove(observer observer: Observer) {
//        observers = observers.filter { (obs, _) in obs !== observer }
//    }

    // MARK: Private

    var observers: [ObservablePair] = []

//    private func has(observer observer: Observer) -> Bool {
//        return observers.reduce(false) { (acc, pair) in acc || pair.observer === observer }
//    }
}

infix operator <- { associativity right precedence 90 }

func <-<T>(lhs: Observable<T>, rhs: T) {
    lhs.value = rhs
}