//
//  StandardDateFormatter.swift
//  AndysToDo
//
//  Created by dillion on 10/28/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation

class StandardDateFormatter : DateFormatter {
    
    override init() {
        super.init()
        self.dateFormat = Constants.standard_full_date_format
        self.timeZone = NSTimeZone.local
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getNextMonthOccurrence(startMonth : String, startDay: String
        ) -> String {
        var year : String = String(Calendar.current.component(.year, from: Date()))
        let now = Date()
        let scheduledDate = self.date(from: "\(startMonth) \(startDay) 00:00 am \(year)")!
        if now < (scheduledDate.addingTimeInterval(Constants.time_interval_for_next_month_occurrence)) {
            year = String(Calendar.current.component(.year, from: Date()))
        }  else {
            year = String(Calendar.current.component(.year, from: Date()) + 1)
        }
        return year
    }
}
