//
//  ShiftTableViewCell.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import UIKit

class ShiftTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ShiftTableViewCell.reuseId)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let subviews = ["name": nameLabel, "time": timeLabel]
        
        add(keyedViewsForAutolayout: subviews)
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[name]-[time]-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: subviews)
        )
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
