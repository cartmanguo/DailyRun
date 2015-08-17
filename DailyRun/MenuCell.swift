//
//  MenuCell.swift
//  DailyRun
//
//  Created by GuoCheng on 15/8/18.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.imageView!.frame = CGRectMake(10,6,32,32);
    }
}
