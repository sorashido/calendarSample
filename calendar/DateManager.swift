//
//  DateManager.swift
//  calendar
//
//  Created by tela on 2017/03/14.
//  Copyright © 2017 tela. All rights reserved.
//

import UIKit

extension Date {
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
}

class DateManager: NSObject {
    
    var currentMonthOfDates = [Date]() //表記する月の配列
    var selectedDate = Date()
    var today = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    //月初めを取得
    func firstDateOfMonth() -> Date {
        var components = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                     from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }

    //月毎の週の数を返す
    func getNumOfWeeks() -> Int {
        //月初めの表示番号を取得
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: firstDateOfMonth())
        
        //その月が何日あるかを計算
        let range = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: selectedDate)
        
        //表記の必要なセル数を計算
        let numberOfWeeks = Int(ceil(CGFloat(ordinalityOfFirstDay+range.length-1)/CGFloat(7.0)))
        return numberOfWeeks
    }

    //月毎のセル数を返す
    func getNumOfDays() -> Int {
        numberOfItems = getNumOfWeeks() * daysPerWeek //
        return numberOfItems
    }
    
    //表記する日を配列へ
    func dateForCellAtIndexPath(_ numberOfItems: Int) {
        //月初めの表示番号を取得
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            let date = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: firstDateOfMonth(), options: NSCalendar.Options(rawValue: 0))!
            currentMonthOfDates.append(date)
        }
    }
    
    //表記の変更
    func conversionDateFormat(_ indexPath: IndexPath) -> String{
        dateForCellAtIndexPath(numberOfItems)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.row])
    }
    //
    func conversionDataFormat(_ indexPath: IndexPath) -> String{
        dateForCellAtIndexPath(numberOfItems)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter.string(from: currentMonthOfDates[indexPath.row])
    }
    func conversionMonth(_ indexPath: IndexPath) ->String{
        dateForCellAtIndexPath(numberOfItems)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        return formatter.string(from: currentMonthOfDates[indexPath.row])
    }
    
    //前月の表示
    func prevMonth(_ date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    //次月の表示
    func nextMonth(_ date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
}
