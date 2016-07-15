import Foundation

extension Date {

    var isToday: Bool {
        let today = Date()

        guard let dayStart = Date.startOf(day: today),
            let dayEnd = Date.endOf(day: today) else {
                return false
        }

        return within(start: dayStart, end: dayEnd)
    }

    private func within(start: Date, end: Date) -> Bool {
        return timeIntervalSince1970 > start.timeIntervalSince1970 && timeIntervalSince1970 < end.timeIntervalSince1970
    }

    private static func startOf(day: Date) -> Date? {
        var components = localComps(forDate: day)

        components.hour = 0
        components.minute = 0
        components.second = 1

        return Calendar.current.date(from: components)
    }

    private static func endOf(day: Date) -> Date? {
        var components = localComps(forDate: day)

        components.hour = 23
        components.minute = 59
        components.second = 59

        return Calendar.current.date(from: components)
    }

    private static func localComps(forDate date: Date) -> DateComponents {
        let units = Calendar.Unit.year.union(.month).union(.day).union(.hour).union(.minute).union(.second)
        return Calendar.current.components(units, from: date)
    }
}
