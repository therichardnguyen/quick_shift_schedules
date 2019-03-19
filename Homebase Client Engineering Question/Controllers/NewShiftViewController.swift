//
//  NewShiftViewController.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import CoreData
import UIKit

class NewShiftViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupViews()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Make a New Shift"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    @objc func save() {
//        guard shift.isValid else {
//            print("Error handling")
//            return
//        }
        
        StorageManager.main.save(managedObjectContext: editingContext,
                                 success: {
                                    print("Save successful")
                                    self.dismiss(animated: true, completion: nil)
        } ,
                                 failure: {
                                    error in print("Save failure: \(error)")
                                    
        })
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

    func setupViews() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(DateTimeCell.self, forCellReuseIdentifier: DateTimeCell.reuseId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let theSection = Section(rawValue: section) else { fatalError() }
        
        return theSection.title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch section {
        case .startDate, .endDate:
            break
        case .employee:
            let controller = EmployeeTableViewController()
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case .shiftColor:
            let controller = ShiftColorTableViewController()
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        
        let cell: UITableViewCell
        switch section {
        case .startDate, .endDate:
            cell = tableView.dequeueReusableCell(withIdentifier: DateTimeCell.reuseId, for: indexPath)
        case .employee, .shiftColor:
            cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        }
        prepare(cell: cell, forSection: section)
        return cell
    }
    
    private func prepare(cell: UITableViewCell, forSection section: Section) {
        switch section {
        case .startDate:
            guard let cell = cell as? DateTimeCell else { return }
            if let date = shift.startDate {
                cell.datePicker.date = date
            }
            cell.datePicker.addTarget(self, action: #selector(updateStartDate(picker:)), for: .valueChanged)
            shift.startDate = cell.datePicker.date
        case .endDate:
            guard let cell = cell as? DateTimeCell else { return }
            if let date = shift.endDate {
                cell.datePicker.date = date
            }
            cell.datePicker.addTarget(self, action: #selector(updateEndDate(picker:)), for: .valueChanged)
            shift.endDate = cell.datePicker.date
        case .employee:
            cell.textLabel?.text = shift.name
        case .shiftColor:
            cell.textLabel?.text = shift.color
        }
    }
    
    @objc func updateStartDate(picker: UIDatePicker) {
        shift.startDate = picker.date
    }
    
    @objc func updateEndDate(picker: UIDatePicker) {
        shift.endDate = picker.date
    }
    
    private enum Section: Int {
        case startDate = 0
        case endDate
        case employee
        case shiftColor
        
        var title: String {
            switch self {
            case .startDate:
                return "Shift starts at?:"
            case .endDate:
                return "Shift ends at?:"
            case .employee:
                return "Employee on shift?:"
            case .shiftColor:
                return "Select a color for the shift calendar:"
            }
        }
        
        static var allSections: [Section] = [.startDate, .endDate, .employee, .shiftColor]
    }
    
    private var editingContext = StorageManager.main.editingContext
    private lazy var shift: Shift = {
        guard let shift = NSEntityDescription.insertNewObject(forEntityName: "Shift", into: editingContext) as? Shift else {
            fatalError("Didn't create a shift, what the heck?")
        }
        return shift
    }()
}

extension NewShiftViewController: ShiftColorTableViewControllerDelegate {
    func didSelect(color: String?) {
        shift.color = color
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

extension NewShiftViewController: EmployeeTableViewControllerDelegate {
    func didSelectEmployee(name: String?, role: String?) {
        shift.name = name
        shift.role = role
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}



private class DateTimeCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DateTimeCell.reuseId)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let subviews = ["picker": datePicker]
        add(keyedViewsForAutolayout: subviews)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ])
    }
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 30
        return picker
    }()

}



