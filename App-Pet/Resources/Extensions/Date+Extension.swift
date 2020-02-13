//
//  Date+Extension.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 28/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

extension Date {
    
    func get(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    func stepMonth(step: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: step, to: self)!
    }
    
    func monthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        formatter.locale = Locale(identifier: "pt-br")
        return formatter.string(from: self).capitalized
    }
    
    func currentDay() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func allMonthDays() -> [Int] {
        let firstWeekDay = Calendar.current.component(.weekday, from: self)
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        var monthDays: [Int] = []
        for _ in 1..<firstWeekDay {
            monthDays.append(0)
        }
        for day in range {
            monthDays.append(day)
        }
        return monthDays
    }
}
