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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/4))
        textLabel.font = UIFont.boldSystemFont(ofSize: 12)//UIFont(name: "HiraKakuProN-W3", size: 12)
        textLabel.textAlignment = NSTextAlignment.center
        
        // Cellに追加
        self.addSubview(textLabel!)
    }
}
