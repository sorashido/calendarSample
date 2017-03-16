//
//  CalendarCollectionViewController.swift
//  ThirdCalendar
//
//  Created by tela on 2016/03/25.
//  Copyright © 2016年 tela. All rights reserved.
//

import UIKit

class CalendarView:UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    var calendarCollectionView:UICollectionView!
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 0.3
    var selectedDate = Date()
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect,current:Int){
        super.init(frame: frame)
        
        // レイアウト作成
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        // コレクションビュー作成
        //画面ぴったりサイズのフレームを生成する
        let calendarFrame:CGRect = CGRect(x: frame.origin.x, y: frame.origin.y+20, width: frame.width, height: frame.height)

        calendarCollectionView = UICollectionView(frame: calendarFrame, collectionViewLayout: layout)
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        //現在の月から数えて表示する月を決める
        if(current>0){
            selectedDate = dateManager.nextMonth(selectedDate)
        }
        else if(current<0){
            selectedDate = dateManager.prevMonth(selectedDate)
        }
        
        calendarCollectionView.backgroundColor = UIColor.lightGray()//grayColor()//UIColor.whiteColor()
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        self.addSubview(calendarCollectionView)
        
        // 曜日の表示
        let weekView:UIView = UIView(frame: CGRect(x: CGFloat(current+1)*self.frame.size.width/2,y: 0,width: self.frame.size.width, height: 18))
        weekView.backgroundColor = UIColor.blackGray()
        for i in 0...6{
            let weekLabel:UILabel = UILabel(frame: CGRect(x: self.frame.size.width/7*CGFloat(i),y: 0,width: self.frame.size.width/7, height: 15))
            weekLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
            weekLabel.text = weekArray[i]
            weekLabel.textColor = UIColor.white
            if i == 0{
                weekLabel.textColor = UIColor.lightRed()
            }
            else if i==6{
                weekLabel.textColor = UIColor.lightBlue()
            }
            weekLabel.textAlignment = NSTextAlignment.center
            weekView.addSubview(weekLabel)
        }
        self.addSubview(weekView)
    }
    
    func setNextMonth(){
        selectedDate = dateManager.nextMonth(selectedDate)
        calendarCollectionView.reloadData()
    }
    
    func setPrevMonth(){
        selectedDate = dateManager.prevMonth(selectedDate)
        calendarCollectionView.reloadData()
    }
    
    func reloadView(){
        calendarCollectionView.reloadData()
    }
    
    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = collectionView.frame.size.height/6
        return CGSize(width: width, height: height)
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    // セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dateManager.daysAcquisition() //
    }
    
    // 月日の表示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
        
        cell.backgroundColor = UIColor.blackGray()
        cell.textLabel.backgroundColor = UIColor.blackGray()
        cell.textLabel.text = ""

        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.white
        }
        cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
        return cell
    }
    
    //headerの月を変更
    func changeHeaderTitle(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }
}

//色の定義
extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
    
    class func blackGray() -> UIColor{
        return UIColor(red: 92.0 / 255, green: 92.0 / 255, blue: 92.0 / 255, alpha: 1.0)
    }
    
    class func lightGray() -> UIColor{
        return UIColor(red: 192.0 / 255, green: 192.0 / 255, blue: 192.0 / 255, alpha: 1.0)
    }    
}
