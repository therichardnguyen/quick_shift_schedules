//
//  StorageManager.swift
//  Homebase Client Engineering Question
//
//  Created by Richard Nguyen on 3/18/19.
//  Copyright © 2019 Richard Nguyen. All rights reserved.
//

import Foundation

import CoreData
import Foundation

class StorageManager {
    
    enum StorageType {
        case persistent
        case volatile
        
        var managedObjectModel: NSManagedObjectModel? {
            guard let url = Bundle.main.url(forResource: name, withExtension: "momd") else { return nil }
            return NSManagedObjectModel(contentsOf: url)
        }
        
        var name: String {
            switch self {
            case .persistent:
                return "Homebase"
            case .volatile:
                return "Homebase"
            }
        }
        
        var storeType: String {
            switch self {
            case .persistent:
                return NSSQLiteStoreType
            case .volatile:
                return NSInMemoryStoreType
            }
        }
        
        var storeUrl: URL? {
            switch self {
            case .persistent:
                guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                    return nil
                }
                return docURL.appendingPathComponent("\(name).sqlite")
            case .volatile:
                return nil
            }
        }
        
    }
    
    private(set) static var main = StorageManager(type: .persistent)
    
    var context: NSManagedObjectContext
    private var coordinator: NSPersistentStoreCoordinator
    
    var editingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = StorageManager.main.context
        return context
    }
    
    init(type: StorageType) {
        guard let managedObjectModel = type.managedObjectModel else {
            fatalError("Error initializing managed object for: \(type)")
        }
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        do {
            if let storeUrl = type.storeUrl {
                try coordinator.destroyPersistentStore(at: storeUrl, ofType: type.storeType, options: [:])
            }
            try coordinator.addPersistentStore(ofType: type.storeType,
                                               configurationName: nil,
                                               at: type.storeUrl,
                                               options: [
                                                NSInferMappingModelAutomaticallyOption: true,
                                                NSMigratePersistentStoresAutomaticallyOption: true
                ])
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }

    func save(managedObjectContext: NSManagedObjectContext, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        do {
            try managedObjectContext.save()
            context.performAndWait {
                do {
                    try context.save()
                    success?()
                } catch {
                    failure?(error)
                    print("Failure to save context: \(error)")
                }
            }
        } catch {
            failure?(error)
            print("Failure to save context: \(error)")
        }
    }
    
    func save(success: (() -> Void)?, failure: ((Error) -> Void)?) {
        context.performAndWait {
            do {
                try context.save()
                success?()
            } catch {
                failure?(error)
                print("Failure to save context: \(error)")
            }
        }
    }
    
}

extension NSManagedObject {
    
    func inContext(_ context: NSManagedObjectContext) -> NSManagedObject {
        return context.object(with: objectID)
    }
    
}
