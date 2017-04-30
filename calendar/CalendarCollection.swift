//
//  CalendarCollectionViewController.swift
//  ThirdCalendar
//
//  Created by tela on 2016/03/25.
//  Copyright © 2016年 tela. All rights reserved.
//

import UIKit

class CalendarCollection:UIView,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var collectionView:UICollectionView!

    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 1.0
    let weekSize: CGFloat = 20
    
    var selectedItem: String = "0"
    var selectedDate = Date()
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, current:Int){
        super.init(frame: frame)
        
        self.setUpDays(current)
    }
    
    func setUpDays(_ current: Int){
        // 表示する月
        if(current > 0){ selectedDate = dateManager.nextMonth(selectedDate)}
        else if(current < 0){ selectedDate = dateManager.prevMonth(selectedDate)}

        // CollectionViewのレイアウトを生成.
        let screenWidth : CGFloat = frame.size.width
        let screenHeight : CGFloat = frame.size.height - weekSize
        let layout = UICollectionViewFlowLayout()
        // CollectionViewを生成
        collectionView = UICollectionView(frame: CGRect(x: screenWidth, y: weekSize, width: frame.size.width, height: CGFloat(screenHeight)), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        // Cellに使われるクラスを登録
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame =  CGRect(x: 0, y: weekSize, width: screenWidth, height: screenHeight)
        self.addSubview(collectionView)
        
        // 曜日の表示
        let weekView:UIView = UIView(frame: CGRect(x: 0,y: 0,width: frame.size.width, height: 20))
                weekView.backgroundColor = UIColor.black
        // 下線の追加
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: weekView.frame.height, width: weekView.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        weekView.layer.addSublayer(bottomLine)
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
        collectionView.reloadData()
    }
    
    func setPrevMonth(){
        selectedDate = dateManager.prevMonth(selectedDate)
        collectionView.reloadData()
    }
    
    func reloadView(){
        collectionView.reloadData()
    }
    
    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfMargin: CGFloat = 10.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = (collectionView.frame.size.height-weekSize)/CGFloat(dateManager.getNumOfWeeks())
        return CGSize(width: width, height: height)
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }

    // セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.getNumOfDays()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap")
        let cell:CalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
        
        selectedItem = dateManager.conversionDateFormat(indexPath)
        cell.backgroundColor = UIColor.white//blackGray()#B64D3F
        collectionView.reloadData()
    }
    
    // 月日の表示
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
        
        cell.backgroundColor = UIColor.blackGray()//blackGray()#B64D3F
        cell.textLabel.backgroundColor = UIColor.blackGray()//UIColor.Gray()//blackGray()
        cell.textLabel.text = ""

        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.white
        }
        if (selectedItem == dateManager.conversionDateFormat(indexPath)){
            cell.textLabel.textColor = UIColor.red
        }
        cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
        return cell
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
        return UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1.0)
    }
    
    class func lightGray() -> UIColor{
        return UIColor(red: 192.0 / 255, green: 192.0 / 255, blue: 192.0 / 255, alpha: 1.0)
    }    
}
