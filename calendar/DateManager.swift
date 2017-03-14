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
    
    //月ごとのセルの数を返すメソッド(現在では表示の都合上から最大値を固定で返している)
    func daysAcquisition() -> Int {
        //        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth())
        let numberOfWeeks = 6//rangeOfWeeks.length //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    //月の初日を取得
    func firstDateOfMonth() -> Date {
        var components = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                     from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    //表記する日にちの取得
    func dateForCellAtIndexPath(_ numberOfItems: Int) {
        // 「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            // 「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // 表示する月の初日から②で計算した差を引いた日付を取得
            let date = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: firstDateOfMonth(), options: NSCalendar.Options(rawValue: 0))!
            // 配列に追加
            currentMonthOfDates.append(date)
        }
    }
    
    //表記の変更
    func conversionDateFormat(_ indexPath: IndexPath,events:inout [Int],is_today:inout Int) -> String{
        dateForCellAtIndexPath(numberOfItems)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        
        //ここで特定の月日だけ表示を変えたい場合の処理を加える
        var eventIndex:Int = 1
        //今日
        let compareFormatter: DateFormatter = DateFormatter()
        compareFormatter.dateFormat = "yyyy,M,d"
        
        if compareFormatter.string(from: today)==compareFormatter.string(from: currentMonthOfDates[indexPath.row]){
            is_today = 1;
        }
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
