//
//  Date+Ext.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 3/19/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

public extension Date {
    static var today: Date {
        return Date()
    }
    
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    static var dayBeforeyesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    static func fromString(string: String, with format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    func string(with format: String = "dd MMM yyyy") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
