//
//  DateExtension.swift
//  Mingle2
//
//  Created by Mingle on 8/22/14.
//  Copyright (c) 2014 Mingle2. All rights reserved.
//

import Foundation

extension Date {
    init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init()
            return nil
        }
    }

    struct Formatter {
        static var iso8601: DateFormatter {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }
        static var iso8601WithoutMilisecond: DateFormatter {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return formatter
        }
        static var iso8601WithoutTime: DateFormatter {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }
    }

    static func dateFromISOString(string: String) -> Date? {
        return Date.Formatter.iso8601.date(from: string) ?? Date.Formatter.iso8601WithoutMilisecond.date(from: string)
    }

    func dateToISOString() -> String {
        return Formatter.iso8601.string(from: self)
    }

    static func dateMediumFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }

    static func timeDifferenceSince(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.second, .minute, .weekOfYear, .hour, .day, .month, .year], from: date, to: Date())
    }

    func timeToString(format: String) -> String {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = format
        return timeFormat.string(from: self)
    }

    func timeAgoSinceDate() -> String {
        let now = Date()
        let earliest = now < self ? now : self
        let latest = earliest == now as Date ? self : now
        let timeFormat = DateFormatter()
        timeFormat.locale = NSLocale.current

        if latest.year != earliest.year {
            timeFormat.dateFormat = "MMM, yy"
        } else if latest.month != earliest.month {
            timeFormat.dateFormat = "MMM d"
        } else if latest.day != earliest.day {
            timeFormat.dateFormat = "MMM d"
        } else {
            timeFormat.dateFormat = "h:mm a"
            timeFormat.amSymbol = "AM"
            timeFormat.pmSymbol = "PM"
        }
        return timeFormat.string(from: earliest)
    }

    func timeToDate() -> String {
        let now = Date()
        let earliest = now < self ? now : self
        let latest = earliest == now as Date ? self : now
        let timeFormat = DateFormatter()
        timeFormat.locale = NSLocale.current

        if latest.year != earliest.year {
            timeFormat.dateFormat = "MMM, yy"
        } else if latest.month != earliest.month {
            timeFormat.dateFormat = "MMM d"
        } else if latest.day != earliest.day {
            timeFormat.dateFormat = "MMM d"
        } else {
            timeFormat.dateFormat = "h:mm a"
            timeFormat.amSymbol = "AM"
            timeFormat.pmSymbol = "PM"
        }
        return timeFormat.string(from: latest)
    }

    func timeAgoSinceDateWithShortFormat() -> String {
        let now = Date()
        let earliest = now < self ? now : self
        let latest = earliest == now as Date ? self : now

        let components = Calendar.current.dateComponents([.second, .minute, .weekOfYear, .hour, .day, .month, .year], from: earliest, to: latest)
        if components.year! >= 1 {
            return "\(components.year ?? 0)y"
        } else if components.month! >= 1 {
            return "\(components.day ?? 0)m"
        } else if components.weekOfYear! >= 1 {
            return "\(components.weekOfYear ?? 0)w"
        } else if components.day! >= 1 {
            return "\(components.day ?? 0)d"
        } else if components.hour! >= 1 {
            return "\(components.hour ?? 0)h"
        } else if components.minute! >= 1 {
            return "\(components.minute ?? 0)min"
        } else {
            return "Just now"
        }
    }

    func distanceToNowAsSecond() -> Int {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        let timeInterval = Int(self.timeIntervalSince(Date()))
        return timeInterval
    }

    func daysBetweenDates(endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: self, to: endDate)
        return components.day ?? 0
    }
    
    func hoursBetweenDates(endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour], from: self, to: endDate)
        return components.hour ?? 0
    }
    
    func minutesBetweenDates(endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.minute], from: self, to: endDate)
        return components.minute ?? 0
    }

    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            return true
        }
        return false
    }

    func isLessThanDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            return true
        }
        return false
    }

    func equalToDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            return true
        }
        return false
    }

    func equalToOnlyDate(dateToCompare: Date) -> Bool {
        return self.toDateString() == dateToCompare.toDateString()
    }

    func equalToOnlyTime(dateToCompare: Date) -> Bool {
        return self.toTimeString() == dateToCompare.toTimeString()
    }

    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy, EEEE"
        return formatter.string(from: self)
    }

    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aa"
        return formatter.string(from: self)
    }

    func timestampString() -> String {
        return "\(timeIntervalSince1970 * 1000)".components(separatedBy: ".").first ?? "0"
    }

    func yearOfGregorianCalendar() -> Int {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let components = calendar.components([.month, .day, .year], from: self)
        return components.year!
    }

    var monthShortString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }

    var monthFullString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }

    func calculateEventDate(endDate: Date?) -> String {
        var eventDate = self.toDateString() + " " + self.toTimeString()
        if let endDate = endDate {
            if self.equalToOnlyDate(dateToCompare: endDate) {
                if !self.equalToOnlyTime(dateToCompare: endDate) {
                    eventDate = self.toDateString() + "\n" + self.toTimeString() + " - " + endDate.toTimeString()
                }
            } else {
                eventDate = self.toDateString() + " " + self.toTimeString() + "\n" + endDate.toDateString() + " " + endDate.toTimeString()
            }
        }
        return eventDate
    }

    func age() -> Int {
        let ageComponents = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: self, to: Date(), options: NSCalendar.Options.matchFirst)
        return ageComponents.year!
    }

//    func distanceToNow() -> String {
//        let formatter = DateIntervalFormatter()
//        formatter.locale = Locale(identifier: kCFBundleLocalizationsKey.sharedInstance().language)
//        let timeInterval = self.timeIntervalSince(Date())
//        if timeInterval > 32000000 { // 1 year
//            return self.stringValue()
//        } else {
//            return formatter.string(forTimeInterval: timeInterval)
//        }
//    }

    func stringValue() -> String {
        return self.stringValueWithFormat("MM-dd-yyyy hh:mm a")
    }

    func stringValueWithFormat(_ format: String, locale: Locale! = nil) -> String {
        let dateFormater = DateFormatter()
        if locale != nil {
            dateFormater.locale = locale
        }
        dateFormater.dateFormat = format
        return dateFormater.string(from: self)
    }

    func yyyymmddFormat() -> String {
        return self.stringValueWithFormat("yyyy-MM-dd")
    }

    var day: Int {
        let cal = Calendar.current
        let com: DateComponents = (cal as NSCalendar).components(NSCalendar.Unit.day, from: self)
        return com.day!
    }

    var year: Int {
        let cal = Calendar.current
        let com: DateComponents = (cal as NSCalendar).components(NSCalendar.Unit.year, from: self)
        return com.year!
    }

    var month: Int {
        let cal = Calendar.current
        let com: DateComponents = (cal as NSCalendar).components(NSCalendar.Unit.month, from: self)
        return com.month!
    }

    func plusDay(_ day: Int) -> Date {
        var component = DateComponents()
        component.day = day
        return (Calendar.current as NSCalendar).date(byAdding: component, to: self, options: [])!
    }

    func plusYear(_ year: Int) -> Date {
        var component = DateComponents()
        component.year = year
        return (Calendar.current as NSCalendar).date(byAdding: component, to: self, options: [])!
    }

    func changeMonthTo(_ month: Int) -> Date {
        var components = (Calendar.current as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year], from: self)
        components.month = month
        return Calendar.current.date(from: components)!
    }

    func earlierThan(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }

    func laterThan(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }

    static func monthInts() -> [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    }

    static func monthStrs() -> [String] {
        return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    }

    static func last2HurgerousYears() -> [Int] {
        let thisYear = (Calendar.current as NSCalendar).components(.year, from: Date()).year
        var years: [Int] = []
        for i in 1...201 {
            years.append(thisYear! - i)
        }
        return years
    }

    static func last2HurgerousYearsString() -> [String] {
        let thisYear = (Calendar.current as NSCalendar).components(.year, from: Date()).year
        var years: [String] = []
        for i in 1...201 {
            years.append(String(thisYear! - i))
        }
        return years
    }

    static func dayAt(_ day: Int, month: Int, year: Int) -> Date {
        var components = (Calendar.current as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year], from: Date())
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components)!
    }

    static func daysInMonths(_ month: Int, plusOneForFeb: Bool = true) -> [Int] {
        let daysRange: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: Date().changeMonthTo(month))
        var days: [Int] = []
        for i in 1...daysRange.length {
            days.append(i)
        }
        if plusOneForFeb && month == 2 && days.count == 28 {
            days.append(29)
        }
        return days
    }

    static func daysInMonthsString(_ month: Int, plusOneForFeb: Bool = true) -> [String] {
        let daysRange: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: Date().changeMonthTo(month))
        var days: [String] = []
        for i in 1...daysRange.length {
            days.append(String(i))
        }
        if plusOneForFeb && month == 2 && days.count == 28 {
            days.append("29")
        }
        return days
    }
    
    static func duration(from start: Date!, to end: Date!) -> Double {
        guard start != nil && end != nil else { return 0.0 }
        return end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
}
