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
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNextMonthOccurrence(startMonth : String, startDay: String
        ) -> String {
        let df = DateFormatter()
        df.dateFormat = Constants.standard_month_format
        let year : String
        let currentMonth = Calendar.current.component(.month, from: Date())
        let scheduledMonth = Calendar.current.component(.month, from: df.date(from: startMonth)!)
        if currentMonth < scheduledMonth {
            year = String(Calendar.current.component(.year, from: Date()))
        } else if currentMonth == scheduledMonth {
            let currentDay = Calendar.current.component(.day, from: Date())
            let scheduledDay = Int(startDay)
            if currentDay <= scheduledDay! {
                year = String(Calendar.current.component(.year, from: Date()))
            } else {
                year = String(Calendar.current.component(.year, from: Date()) + 1)
            }
        } else {
            year = String(Calendar.current.component(.year, from: Date()) + 1)
        }
        return year
    }
}
