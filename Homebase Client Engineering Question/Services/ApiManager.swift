//
//  ApiManager.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import CoreData
import Foundation

class APIManager {
    
    static func fetchShifts() {
        guard let url = Bundle.main.url(forResource: "shifts", withExtension: "json") else {
            fatalError("Unable to find shifts.json. You goofed.")
        }
        
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let shiftsArray = jsonResult["shifts"] as? [[String: String]] {
                for shiftData in shiftsArray {
                    guard let shift = NSEntityDescription.insertNewObject(forEntityName: "Shift", into: StorageManager.main.context) as? Shift else {
                        fatalError("Didn't create a shift, what the heck?")
                    }
                    shift.name = shiftData["name"]
                    shift.role = shiftData["role"]
                    if let endDate = shiftData["end_date"] {
                        shift.endDate = Formatter.date.api.date(from: endDate)
                    }
                    if let startDate = shiftData["start_date"] {
                        shift.startDate = Formatter.date.api.date(from: startDate)
                    }
                    shift.color = shiftData["color"]
                    print(shift)
                }
            }
            StorageManager.main.save(success: { print("Successfully saved") }, failure: { error in print("Failed to save: \(error)") })
        } catch {
            fatalError("Failed to parse convert shifts.json to Data")
        }
    }
}
