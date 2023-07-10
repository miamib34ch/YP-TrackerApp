//
//  UITableCell+Extension.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.06.2023.
//

import UIKit

extension UITableViewCell {

    func addSeperator(accessoryWidth: CGFloat?) {
        let seperator = UIView(frame: CGRect(x: 16,
                                             y: 0,
                                             width: contentView.frame.width + ( accessoryWidth ?? 0) - 32,
                                             height: 1))
        seperator.backgroundColor = UIColor(named: "#AEAFB4")
        contentView.addSubview(seperator)
    }

    func deleteSeperator() {
        contentView.subviews[contentView.subviews.count-1].removeFromSuperview()
    }

}
