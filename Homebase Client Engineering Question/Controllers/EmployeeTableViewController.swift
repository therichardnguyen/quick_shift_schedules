//
//  EmployeeTableViewController.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import UIKit

import CoreData
import UIKit

protocol EmployeeTableViewControllerDelegate: class {
    func didSelectEmployee(name: String?, role: String?)
}

class EmployeeTableViewController: UITableViewController {
    
    weak var delegate: EmployeeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        prepare(cell: cell, withObject: object)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shift = fetchedResultsController.object(at: indexPath) as? [String: String]
        delegate?.didSelectEmployee(name: shift?["name"], role: shift?["role"])
    }

    func prepare(cell: UITableViewCell, withObject object: NSDictionary) {
        guard let shift = object as? [String: String] else { return }
        
        cell.textLabel?.text = "\(shift["name"] ?? "") (\(shift["role"] ?? ""))" // Be smarter about this
    }
    
    private var fetchedResultsController: NSFetchedResultsController<NSDictionary> = {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Shift")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Shift.name, ascending: true)]
        fetchRequest.propertiesToFetch = ["name", "role"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: StorageManager.main.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }()
    
}

extension EmployeeTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
