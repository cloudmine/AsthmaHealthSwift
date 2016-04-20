import ResearchKit

extension ORKCollectionResult {
    func findResult<T:ORKResult>() -> T? {
        guard let results = self.results where results.count > 0 else {
            return nil
        }

        if let resultT = results.filter({ nil != $0 as? T}).first as? T{
            return resultT
        }

        return results.flatMap { $0 as? ORKCollectionResult }.flatMap { $0.findResult() }.first
    }
}
