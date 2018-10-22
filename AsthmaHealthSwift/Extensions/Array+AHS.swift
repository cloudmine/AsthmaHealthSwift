import ResearchKit

extension Array where Element: ORKTaskResult {

    var anyCompletedToday: Bool {
        return self.reduce(false) { (acc, taskResult) in
            let isToday = taskResult.endDate.isToday
            return acc || isToday
        }
    }
}
