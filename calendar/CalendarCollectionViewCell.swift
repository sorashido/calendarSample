//
//  CalendarCollectionViewCell.swift
//  ThirdCalendar
//
//  Created by tela on 2016/03/25.
//  Copyright © 2016年 tela. All rights reserved.
//


import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel!
    var eventLabel1: UILabel!
    var eventLabel2: UILabel!
    var eventLabel3: UILabel!
    var eventLabel4: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // UILabelを生成
//        textLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, self.frame.height/2))
//        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
//        textLabel.textAlignment = NSTextAlignment.Center
//
//        // Cellに追加
//        self.addSubview(textLabel!)
        //self.contentView.addSubview(textLabel!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/4))
        textLabel.font = UIFont.boldSystemFont(ofSize: 12)//UIFont(name: "HiraKakuProN-W3", size: 12)
        textLabel.textAlignment = NSTextAlignment.center

        eventLabel1 = UILabel(frame: CGRect(x: 0,y: self.frame.height/4, width: self.frame.width,height: self.frame.height*3/16))
        eventLabel1.font = UIFont(name: "HiraKakuProN-W3",size: 5)
        eventLabel1.textAlignment = NSTextAlignment.center
        
        eventLabel2 = UILabel(frame: CGRect(x: 0, y: self.frame.height*7/16, width: self.frame.width, height: self.frame.height*3/16))
        eventLabel2.font = UIFont(name: "HiraKakuProN-W3",size: 5)
        eventLabel2.textAlignment = NSTextAlignment.center

        eventLabel3 = UILabel(frame: CGRect(x: 0, y: self.frame.height*10/16, width: self.frame.width, height: self.frame.height*3/16))
        eventLabel3.font = UIFont(name: "HiraKakuProN-W3",size: 5)
        eventLabel3.textAlignment = NSTextAlignment.center

        eventLabel4 = UILabel(frame: CGRect(x: 0, y: self.frame.height*13/16, width: self.frame.width, height: self.frame.height*3/16))
        eventLabel4.font = UIFont(name: "HiraKakuProN-W3",size: 5)
        eventLabel4.textAlignment = NSTextAlignment.center
        
        // Cellに追加
        self.addSubview(textLabel!)
        self.addSubview(eventLabel1!)
        self.addSubview(eventLabel2!)
        self.addSubview(eventLabel3!)
        self.addSubview(eventLabel4!)
    }
}
