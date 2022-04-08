//
//  Date+Extension.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 06/04/2022.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
            
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func isSameDay(_ date: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: date)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func isSameMonth(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.month], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}
