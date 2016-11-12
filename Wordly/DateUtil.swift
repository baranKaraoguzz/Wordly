//
//  DateUtil.swift
//  Wordly
//
//  Created by eposta developer on 28/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


class DateUtil {

    //# MARK: - Show Date
    //show formatted date for debugging
    static func showFormattedDate(d : NSDate){
        let date = d
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let now = dateformatter.stringFromDate(date)
        debugPrint(" #  -  \(now)")
    }
    
     //# MARK: - Get Hour
    //get current hour as a 24-hour cycle.
    static func getCurrentHourInt() -> Int
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        let hourString = formatter.stringFromDate(NSDate())
        let hour = Int(hourString)
        return hour!
    }

    //# MARK: - Get Day
  static func getDayOfWeek(today:String)->Int? {
    
    // day of the week as a number sunday 1 ... saturday 7
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }


}
    // day of the week as a number sunday 1 ... saturday 7
    static func getDayOfTheWeek () -> Int{
    
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let date = NSDate()
    let calendarComps = calendar.componentsInTimeZone(NSTimeZone.defaultTimeZone(), fromDate: date)
    let weekDay = calendarComps.weekday
    let day = calendarComps.day
    let h = calendarComps.hour
    let min = calendarComps.minute
    debugPrint("day : \(day) weekday : \(weekDay) hour : \(h) minute : \(min)")
    return weekDay
    
        
            }
  
    

}