//
//  WeeklyCalendarViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/31.
//

import UIKit
import RxSwift
import RxCocoa

struct WeeklyCalendarDataModel {
    let year: Int
    let month: Month
    let weekDay: WeekDay
    let day: Int
    let events: [NSObject]
    let isFirst: Bool
    
    init(year: Int, month: Month, weekDay: WeekDay, day: Int) {
        self.year = year
        self.month = month
        self.weekDay = weekDay
        self.day = day
        self.isFirst = false
        self.events = [NSObject]() // Mock Data
    }
    
    init(isFirst: Bool) {
        self.year = 1900
        self.month = .january
        self.weekDay = .sunday
        self.day = 11
        self.isFirst = isFirst
        self.events = [NSObject]() // Mock Data
    }
}

class WeeklyCalendarViewModel {
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var monthIndex: Int = 0
    private var year: Int = 0
    private var today = 0
    private var weekDay: WeekDay = .sunday
    private let date: Date

    init(date: Date) {
        self.date = date
    }
    
    private func calcDate(date: Date) {
        monthIndex = Calendar.current.component(.month, from: date)
        monthIndex -= 1
        
        year = Calendar.current.component(.year, from: date)
        today = Calendar.current.component(.day, from: date)
        weekDay = WeekDay(rawValue: Calendar.current.component(.weekday, from: date) - 1) ?? .sunday
        
        // 윤년
        if monthIndex == 1 && year % 4 == 0 {
            numOfDaysInMonth[monthIndex] = 29
        }
    }
    
    private func days(year: Int, month: Int, weekDay: WeekDay) -> [WeeklyCalendarDataModel] {
        var dayModels = [WeeklyCalendarDataModel]()
        let maxCount = 7
        let maxDay = numOfDaysInMonth[month]
        
        // Meanless Value
        dayModels.append(WeeklyCalendarDataModel(isFirst: true))
        
        for index in 0..<maxCount {
            let day = today + index
            let weekDayIndex = (weekDay.rawValue + index) % 7
            let isNextYear = month + 1 > 11
            let isNextMonth = day > maxDay
    
            if isNextMonth {
                if isNextYear {
                    let model = WeeklyCalendarDataModel(year: year + 1,
                                                        month: .january,
                                                        weekDay: WeekDay(rawValue: weekDayIndex) ?? .sunday,
                                                        day: day - maxDay)
                    dayModels.append(model)
                } else {
                    let model = WeeklyCalendarDataModel(year: year,
                                                        month: Month(rawValue: month + 1) ?? .january,
                                                        weekDay: WeekDay(rawValue: weekDayIndex) ?? .sunday,
                                                        day: day - maxDay)
                    dayModels.append(model)
                }
            } else {
                let model = WeeklyCalendarDataModel(year: year,
                                                    month: Month(rawValue: month) ?? .january,
                                                    weekDay: WeekDay(rawValue: weekDayIndex) ?? .sunday,
                                                    day: day)
                dayModels.append(model)
            }
        }
        return dayModels
    }
}

extension WeeklyCalendarViewModel {
    func dateModel() -> Observable<[WeeklyCalendarDataModel]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            self.calcDate(date: self.date)
            let dayModels = self.days(year: self.year, month: self.monthIndex, weekDay: self.weekDay)
            observer.onNext(dayModels)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

