//
//  DateType.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/01.
//

import Foundation

enum DateType {
    case timezone
    case schedule
    case yearMonthDay
    case yearMonth
    case year
    case monthDay
    case month
    case day
    case time

    //TODO: FilePrivate
    var formatter: DateFormatter {
        let dateForamtter = DateFormatter()
        switch self {
        case .timezone:
            dateForamtter.dateFormat = "YYYY-MM-DDThh:mm:ss TZD"
        case .schedule:
            dateForamtter.dateFormat = "yyyy.M.dd(E)"
        case .yearMonthDay:
            dateForamtter.dateFormat = "yyyy.M d"
        case .yearMonth:
            dateForamtter.dateFormat = "yyyy.M"
        case .year:
            dateForamtter.dateFormat = "yyyy"
        case .monthDay:
            dateForamtter.dateFormat = "M.dd"
        case .month:
            dateForamtter.dateFormat = "M"
        case .day:
            dateForamtter.dateFormat = "d"
        case .time:
            dateForamtter.dateFormat = "a h:mm"
        }
        return dateForamtter
    }

    //TODO: FilePrivate
    func date(year: Int, month: Int, day: Int) -> Date? {
        let dateString = "\(year).\(month) \(day)"
        return self.formatter.date(from: dateString)
    }

    //TODO: FilePrivate
    func dateToString(_ date: Date) -> String {
        return self.formatter.string(from: date)
    }
}

// MARK: String

extension String {
    func date(with dateType: DateType) -> Date? {
        return dateType.formatter.date(from: self)
    }
}

// MARK: Date

extension Date {
    func string(with dateType: DateType) -> String {
        return dateType.formatter.string(from: self)
    }
}

// MARK: TimeInterval(Double)

extension TimeInterval {
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
}
