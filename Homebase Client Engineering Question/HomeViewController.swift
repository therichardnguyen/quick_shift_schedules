//
//  ViewController.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.fetchShifts()
        setupViews()
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Shifts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddModal))
    }

    func setupViews() {
        let shiftView = shiftList.tableView!
        let subviews = ["list": shiftView]
        
        view.add(keyedViewsForAutolayout: subviews)
        addChild(shiftList)
        shiftList.didMove(toParent: self)
        NSLayoutConstraint.activate([
            shiftView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shiftView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shiftView.topAnchor.constraint(equalTo: view.topAnchor),
            shiftView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
    
    @objc func openAddModal() {

    }

    private let shiftList = ShiftsTableViewController()
}

