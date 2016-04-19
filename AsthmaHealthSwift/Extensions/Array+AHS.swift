import ResearchKit

extension Array where Element: ORKTaskResult {

    var anyCompletedToday: Bool {
        return self.reduce(false) { (acc, taskResult) in
            guard let isToday = taskResult.endDate?.isToday else {
                return acc || false
            }

            return acc || isToday
        }
    }
}