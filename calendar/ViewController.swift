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
var bottomDay: UILabel!

var calView = CalendarView()
var listView = CalendarTableView()
var settingView = SettingViewController()

class ViewController: UIViewController {

    @IBAction func backToTop(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Slide Calendar */
        view.backgroundColor = .blackGray()
        let listHeight = CGFloat(250)
        let margin = CGFloat(30)

        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - listHeight)
        calView = CalendarView(frame: frame)
        self.view.addSubview(calView)
        
        /* 文字の追加 */
        headerYear = UILabel(frame: CGRect(x: 15, y: 40, width: self.view.bounds.width, height: 30))
        headerYear.text = calView.changeheaderYear(Date())//changeheaderYear(currentMonth.selectedDate as Date)
        headerYear.font = UIFont.boldSystemFont(ofSize: 24)//UIFont(name: "HiraKakuProN-W3", size: 12)
        headerYear.textAlignment = NSTextAlignment.left
        headerYear.textColor = .lightRed()
        
        headerMonth = UILabel(frame: CGRect(x: 80, y: 40, width: self.view.bounds.width, height: 30))
        headerMonth.text = calView.changeheaderMonth(Date())//changeheaderMonth(currentMonth.selectedDate as Date)
        headerMonth.font = UIFont.boldSystemFont(ofSize: 18)//UIFont(name: "HiraKakuProN-W3", size: 12)
        headerMonth.textAlignment = NSTextAlignment.left
        headerMonth.textColor = .white
        
        bottomDay = UILabel(frame: CGRect(x: 0, y: self.view.frame.height-listHeight, width: self.view.bounds.width, height: margin))
        bottomDay.text = calView.changebottomDay(Date())
        bottomDay.font = UIFont(name: "HiraKakuProN-W3", size: 14)
        bottomDay.textAlignment = NSTextAlignment.center
        bottomDay.backgroundColor = .blackGray()
        bottomDay.textColor = .white

        // 上線の追加
        let topLine = CALayer()
        topLine.frame = CGRect(x: 0, y: 0, width: bottomDay.frame.width, height: 1.0)
        topLine.backgroundColor = UIColor.lightGray.cgColor
        bottomDay.layer.addSublayer(topLine)

        self.view.addSubview(headerYear!)
        self.view.addSubview(headerMonth!)
        self.view.addSubview(bottomDay!)

        /* Listの作成 */
        let frame2 = CGRect(x: 0, y: self.view.frame.height-listHeight + margin, width: self.view.frame.width, height: listHeight)
        listView = CalendarTableView(frame: frame2)
        self.view.addSubview(listView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                settingView.fetchEvents()
            }
        }
        listView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

