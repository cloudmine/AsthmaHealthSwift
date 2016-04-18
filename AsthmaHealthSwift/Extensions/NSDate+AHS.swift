import Foundation

extension NSDate {

    var isToday: Bool {
        let today = NSDate()

        guard let dayStart = NSDate.startOf(day: today),
            let dayEnd = NSDate.endOf(day: today) else {
                return false
        }

        return within(start: dayStart, end: dayEnd)
    }

    private func within(start start: NSDate, end: NSDate) -> Bool {
        return timeIntervalSince1970 > start.timeIntervalSince1970 && timeIntervalSince1970 < end.timeIntervalSince1970
    }

    private static func startOf(day day: NSDate) -> NSDate? {
        let components = localComps(forDate: day)

        components.hour = 0
        components.minute = 0
        components.second = 1

        return NSCalendar.currentCalendar().dateFromComponents(components)
    }

    private static func endOf(day day: NSDate) -> NSDate? {
        let components = localComps(forDate: day)

        components.hour = 23
        components.minute = 59
        components.second = 59

        return NSCalendar.currentCalendar().dateFromComponents(components)
    }

    private static func localComps(forDate date: NSDate) -> NSDateComponents {
        let units = NSCalendarUnit.Year.union(.Month).union(.Day).union(.Hour).union(.Minute).union(.Second)
        return NSCalendar.currentCalendar().components(units, fromDate: date)
    }
}
