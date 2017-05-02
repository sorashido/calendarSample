//
//  CalendarTableView.swift
//  calendar
//
//  Created by Daichi Shibata on 2017/05/01.
//  Copyright © 2017 tela. All rights reserved.
//

import UIKit

class CalendarTableView:UITableView, UITableViewDelegate, UITableViewDataSource{
    // ステータスバーの高さ
    /// List of example table view cells
    let demoItems : [[String:String]] = [
        ["title" : "This is an example badge", "badge": "1"],
        ["title" : "This is a second example badge", "badge": "123"],
        ["title" : "A text badge", "badge": "Warning!"],
        ["title" : "Another text badge with a really long title!", "badge": "Danger!"],
        ]

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.separatorColor = .clear
        self.backgroundColor = .blackGray()
        
        self.dataSource = self
        self.delegate = self
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier:"BadgedCell") as? TDBadgedCell;
        if(cell == nil) {
            cell = TDBadgedCell(style: .default, reuseIdentifier: "BadgedCell");
        }
        
        cell?.backgroundColor = .blackGray()
        cell?.textLabel!.textColor = .white
        cell?.textLabel!.text = demoItems[indexPath.row]["title"]
        cell?.badgeString = demoItems[indexPath.row]["badge"]!
        
        // Set accessory views for two badges
        if(indexPath.row == 0) {
            cell?.accessoryType = .disclosureIndicator
        }
        
        if(indexPath.row == 1) {
            cell?.badgeColor = .lightGray
            cell?.badgeTextColor = .black
            cell?.accessoryType = .checkmark
        }
        
        // Set background colours for two badges
        if(indexPath.row == 2) {
            cell?.badgeColor = .orange
        } else if(indexPath.row == 3) {
            cell?.badgeColor = .red
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return 4
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // セルの高さを設定
        return 50
    }
}
