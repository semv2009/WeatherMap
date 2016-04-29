//
//  NSDate+StringRepresentation.swift
//  WeatherMap
//
//  Created by developer on 27.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

extension NSDate {
    func getTimeFormat() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate))
    }
    
    func getDayFormat() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate))
    }
}
