//
//  CoreData.swift
//  Home Report
//
//  Created by Andi Setiyadi on 12/13/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import Foundation

// STEP 1
import CoreData

// STEP 2
class CoreData {
    let model = "Car Inventory"
    
    // STEP 3
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count-1]
    }()
    
    // *****
    // ***** DocumentDirectory is the recommended place to store users' data *****
    // *****
    
    
    // STEP 4
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.model, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    // STEP 5
    // Store coordinator mediates the object model and the persistent store
    
    private lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.model)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }
        catch {
            fatalError("Error adding persistence store")
        }
        
        return coordinator
    }()
    
    // STEP 6
    lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistenceStoreCoordinator
        return context
    }()
    
    // STEP 7
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch {
                print("Error saving context")
                abort()
            }
        }
    }
}
