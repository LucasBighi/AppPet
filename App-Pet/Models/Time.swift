//
//  Time.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 01/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

enum Formater: String {
    case fullDateTime = "dd 'de' LLLL 'de' yyyy 'às' HH:mm"
    case fullDate = "dd 'de' LLLL 'de' yyyy"
    case time = "HH:mm"
    case dayName = "EE"
    case monthName = "LLLL"
}

class Time {
    
    static let current = Time()
    private let date = Date()
    let calendar = Calendar.current
    let locale = Locale(identifier: "pt-br")
    private let fullDateFormatter = DateFormatter()
    private let dayNameFormatter = DateFormatter()
    private let monthNameFormatter = DateFormatter()
    private var dateComponents = DateComponents()
    
    var components: DateComponents {
        return calendar.dateComponents([.year, .day, .hour, .minute], from: date)
    }
    
    var dayName: String {
        dayNameFormatter.dateFormat = "EE"
        dayNameFormatter.locale = locale
        return dayNameFormatter.string(from: date).capitalized
    }
    
    var monthName: String {
        monthNameFormatter.dateFormat = "LLLL"
        monthNameFormatter.locale = locale
        return monthNameFormatter.string(from: date).capitalized
    }
    
    var fullDate: String {
        fullDateFormatter.dateFormat = "dd LLLL yyyy"
        fullDateFormatter.locale = locale
        return fullDateFormatter.string(from: date).capitalized
    }
    
    var day: Int
    var month: Int
    let year: Int
    let currentDate: Date
    //var monthDays: [Int]
    var firstWeekDay: Int
    
    func formatDate(date: Date, format: Formater) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "pt-br")
        return formatter.string(from: date)
    }
    
    func getDate(from string: String, format: Formater) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "pt-br")
        if let date = formatter.date(from: string) {
            return date
        }
        return Date()
    }
    
    func getAge(from bornDate: Date) -> Int {
        let ageComponents = calendar.dateComponents([.year], from: bornDate, to: self.date)
        return ageComponents.year!
    }
    
    func monthDays(of date: Date) -> [Int] {
        let firstWeekDay = calendar.component(.weekday, from: date)
        let range = calendar.range(of: .day, in: .month, for: date)!
        var monthDays = [0]
        for day in range {
            monthDays.append(day)
        }
        for _ in 1..<firstWeekDay {
            monthDays.append(0)
        }
        return monthDays
    }
    
    private init(){
        self.day = calendar.component(.day, from: date)
        self.month = calendar.component(.month, from: date)
        self.year = calendar.component(.year, from: date)
        self.dateComponents = DateComponents(year: year, month: month)
        self.currentDate = calendar.date(from: dateComponents)!
        self.firstWeekDay = calendar.component(.weekday, from: date)
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        //var monthDays = [0]
//        for day in range {
//            monthDays.append(day)
//        }
//        for _ in 1..<firstWeekDay {
//            monthDays.append(0)
//        }
        //self.monthDays = monthDays
    }
}
