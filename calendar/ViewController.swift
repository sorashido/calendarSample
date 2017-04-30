//
//  ViewController.swift
//  calendar
//
//  Created by tela on 2017/03/14.
//  Copyright © 2017 tela. All rights reserved.
//

import UIKit

// UILabelを生成
var headerYear: UILabel!
var headerMonth: UILabel!

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height)
        let calView = CalendarView(frame: frame)
        self.view.addSubview(calView)
        
        /*年月の表示*/
        headerYear = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.bounds.width, height: 100))
        headerYear.text = "2017"//changeheaderYear(currentMonth.selectedDate as Date)
        headerYear.font = UIFont.boldSystemFont(ofSize: 24)//UIFont(name: "HiraKakuProN-W3", size: 12)
        headerYear.textAlignment = NSTextAlignment.left
        headerYear.textColor = UIColor.lightRed()
        
        headerMonth = UILabel(frame: CGRect(x: 80, y: 0, width: self.view.bounds.width, height: 100))
        headerMonth.text = "April"//changeheaderMonth(currentMonth.selectedDate as Date)
        headerMonth.font = UIFont.boldSystemFont(ofSize: 18)//UIFont(name: "HiraKakuProN-W3", size: 12)
        headerMonth.textAlignment = NSTextAlignment.left
        headerMonth.textColor = UIColor.white
        
        // Cellに追加
        self.view.addSubview(headerYear!)
        self.view.addSubview(headerMonth!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

