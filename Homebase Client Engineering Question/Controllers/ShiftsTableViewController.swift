//
//  ShiftsTableViewController.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import UIKit

import CoreData
import UIKit

class ShiftsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShiftTableViewCell.self, forCellReuseIdentifier: ShiftTableViewCell.reuseId)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ShiftTableViewCell.reuseId, for: indexPath)
        prepare(cell: cell, withObject: object)
        return cell
    }
    
    func prepare(cell: UITableViewCell, withObject object: NSManagedObject?) {
        guard let cell = cell as? ShiftTableViewCell, let shift = object as? Shift else { return }
        cell.nameLabel.text = "\(shift.name ?? "") (\(shift.role ?? ""))"
        if let colorName = shift.color {
            var color: UIColor
            switch colorName {
            case "red":
                color = UIColor.red
            case "green":
                color = UIColor.green
            case "blue":
                color = UIColor.blue
            default:
                color = UIColor.white
            }
            cell.backgroundColor = color.withAlphaComponent(0.1)
        }
        if let start = shift.startDate, let end = shift.endDate {
            let beginning = Formatter.shiftList.startInterval.string(from: start)
            let end = Formatter.shiftList.endInterval.string(from: end)
            cell.timeLabel.text = "\(beginning)\(end)"
        } else {
            cell.timeLabel.text = "Invalid shift start/end times"
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Shift> = {
        let fetchRequest: NSFetchRequest<Shift> = Shift.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Shift.startDate, ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: StorageManager.main.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
}

extension ShiftsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
