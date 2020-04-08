//
//  NumberFormatter+Ext.swift
//  CONVID-19-NA
//
//  Created by ARMSTRONG on 3/19/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static func currency(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
        
        return "$" + formattedValue
    }
}
