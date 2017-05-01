//
//  CalendarView.swift
//  calendar
//
//  Created by Daichi Shibata on 2017/04/30.
//  Copyright © 2017 tela. All rights reserved.
//

import UIKit

class CalendarView: UIView, UIScrollViewDelegate{

    var scrollView: UIScrollView!
    var pageControll: UIPageControl!
    
    var currentMonth: CalendarCollection!
    var prevMonth: CalendarCollection!
    var nextMonth: CalendarCollection!
    
    var didScloll:Bool = true

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame:CGRect){
        super.init(frame: frame)

        let screenWidth : CGFloat = frame.size.width
        let screenHeight : CGFloat = frame.size.height-60

        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = UIColor.white//blackGray()
        scrollView.contentSize = CGSize(width: frame.size.width * 3.0, height: screenHeight)
        scrollView.contentOffset = CGPoint(x: screenWidth , y: 0.0)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        self.addSubview(scrollView)
        
        //現在、先月、前月を加える
        currentMonth = CalendarCollection(frame:CGRect(x: frame.size.width, y: 0,width: screenWidth, height: screenHeight),current:0)
        nextMonth = CalendarCollection(frame:CGRect(x: frame.size.width*2, y: 0, width: screenWidth, height: screenHeight),current:1)
        prevMonth = CalendarCollection(frame:CGRect(x: 0, y: 0,width: screenWidth, height: screenHeight),current:-1)
        scrollView.addSubview(currentMonth)
        scrollView.addSubview(nextMonth)
        scrollView.addSubview(prevMonth)
    }
    
    /*スクロールが行われた時の処理*/
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos:CGFloat  = scrollView.contentOffset.x / scrollView.bounds.size.width
        let deff:CGFloat = pos - 1.0
        if fabs(deff) >= 1.0 && didScloll{
            didScloll = false
            
            //scrollView
            scrollView.backgroundColor = UIColor.clear
            
            if (deff > 0) {
                self.showNextView()
            } else {
                self.showPrevView()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didScloll = true
    }
    
    /*次の月に移動*/
    func showNextView(){
        prevMonth.setNextMonth()
        currentMonth.setNextMonth()
        nextMonth.setNextMonth()

        resetContentOffSet()
        
        headerMonth.text = changeheaderMonth(currentMonth.selectedDate)
        headerYear.text = changeheaderYear(currentMonth.selectedDate)
        currentMonth.reloadView()
    }
    
    /*前月に移動*/
    func showPrevView(){
        prevMonth.setPrevMonth()
        currentMonth.setPrevMonth()
        nextMonth.setPrevMonth()

        resetContentOffSet()
        
        headerMonth.text = changeheaderMonth(currentMonth.selectedDate)
        headerYear.text = changeheaderYear(currentMonth.selectedDate)
        currentMonth.reloadView()
    }
    
    /*移動後の位置を直す*/
    func resetContentOffSet (){
        //position調整
        currentMonth.frame = CGRect(x: frame.size.width, y: 0,width: frame.width, height: frame.height)
        nextMonth.frame = CGRect(x: frame.size.width*CGFloat(2), y: 0,width: frame.width, height: frame.height)
        prevMonth.frame = CGRect(x: 0, y: 0,width: frame.width, height: frame.height)

        //現在の位置を変更
        scrollView.contentOffset = CGPoint(x:self.bounds.width , y:0.0);
    }
    
    //headerの月を変更
    func changeheaderYear(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }
    func changeheaderMonth(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }

}
