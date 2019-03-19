import UIKit

extension UIView {
    
    @objc func add(subviewsForAutolayout subviews: [UIView]) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }
    
    @objc func add(keyedViewsForAutolayout views: [String: UIView]) {
        add(subviewsForAutolayout: Array(views.values))
    }
    
    @discardableResult func addVFL(_ format: String, options: NSLayoutConstraint.FormatOptions = [],
                                   metrics: [String: Any]? = nil,
                                   views: [String: Any]) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics,
                                                         views: views)
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
}

extension UITableViewCell {
    
    @objc static var reuseId: String {
        return String(describing: self)
    }
    
    var tableView: UITableView? {
        var view = self.superview
        while view != nil && !(view is UITableView) {
            view = view?.superview
        }
        
        return view as? UITableView
    }
    
    override func add(subviewsForAutolayout subviews: [UIView]) {
        contentView.add(subviewsForAutolayout: subviews)
    }
    
    override func add(keyedViewsForAutolayout views: [String: UIView]) {
        add(subviewsForAutolayout: Array(views.values))
    }
    
    @objc func resetContent() {
        // No-op: This should be overridden by subclasses to reset the content of the cell
    }
    
    func setSeparatorInsetToZero() {
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
    }
    
}

extension UITableViewHeaderFooterView {
    
    static var reuseId: String {
        return String(describing: self)
    }
    
    override func add(subviewsForAutolayout subviews: [UIView]) {
        contentView.add(subviewsForAutolayout: subviews)
    }
    
    override func add(keyedViewsForAutolayout views: [String: UIView]) {
        add(subviewsForAutolayout: Array(views.values))
    }
}//
//  UIViewConvenience.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import Foundation
