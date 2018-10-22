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

        let date = NSCalendar.current.date(from: components as DateComponents)
        
        return date
    }

    private static func endOf(day: Date) -> Date? {
        var components = localComps(forDate: day)

        components.hour = 23
        components.minute = 59
        components.second = 59

        let date = NSCalendar.current.date(from: components as DateComponents)
        
        return date
    }

    private static func localComps(forDate date: Date) -> DateComponents {
        let set = Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second)
        
        return NSCalendar.current.dateComponents(set, from: date)
    }
}
