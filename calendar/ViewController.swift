//
//  ViewController.swift
//  calendar
//
//  Created by tela on 2017/03/14.
//  Copyright © 2017 tela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var pageControll: UIPageControl!
    
    var currentMonth: CalendarView!
    var prevMonth: CalendarView!
    var nextMonth: CalendarView!
    
    let pageNum = 3
    
    // UILabelを生成
    var headerTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*画面の設定*/
        //UIViewController.viewの座標取得
        let x:CGFloat = self.view.bounds.origin.x
        let y:CGFloat = self.view.bounds.origin.y+80//topMargin
        
        //UIViewController.viewの幅と高さを取得
        let width:CGFloat = self.view.bounds.width
        let height:CGFloat = self.view.bounds.height
        
        //上記より画面ぴったりサイズのフレームを生成する
        let frame:CGRect = CGRect(x: x, y: y, width: width, height: height)
        self.scrollView = UIScrollView(frame: frame)
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(pageNum), height: self.view.bounds.height)
        self.scrollView.contentOffset = CGPoint(x: self.view.bounds.width , y: 0.0);//オフセット
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(self.scrollView)
        
        /*現在、先月、前月を加える*/
        currentMonth = CalendarView(frame:CGRect(x: self.view.bounds.width/2, y: 0,width: self.view.bounds.width, height: self.view.bounds.height),current:0)
        nextMonth = CalendarView(frame:CGRect(x: self.view.bounds.width*CGFloat(1), y: 0,width: self.view.bounds.width, height: self.view.bounds.height),current:1)
        prevMonth = CalendarView(frame:CGRect(x: 0, y: 0,width: self.view.bounds.width, height: self.view.bounds.height),current:-1)
        self.scrollView.addSubview(currentMonth)
        self.scrollView.addSubview(nextMonth)
        self.scrollView.addSubview(prevMonth)
        
        /*年月の表示*/
        headerTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        headerTitle.text = changeHeaderTitle(currentMonth.selectedDate as Date)
        headerTitle.font = UIFont.boldSystemFont(ofSize: 18)//UIFont(name: "HiraKakuProN-W3", size: 12)
        headerTitle.textAlignment = NSTextAlignment.center
        // Cellに追加
        self.view.addSubview(headerTitle!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //headerの月を変更
    func changeHeaderTitle(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }

}

