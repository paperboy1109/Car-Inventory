//
//  CarService.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 12/21/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import Foundation
import CoreData

class CarService {
    
    var managedObjectContext: NSManagedObjectContext!
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getCarInventory() -> [Car] {
        let request = NSFetchRequest(entityName: "Car")
        request.fetchBatchSize = 16
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.executeFetchRequest(request) as! [Car]
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    func getTotalCarInInventorySlow() -> Int {
        let request = NSFetchRequest(entityName: "Car")
        let results: [Car]
        
        do {
            results = try managedObjectContext.executeFetchRequest(request) as! [Car]
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results.count
    }
    
    func getTotalSUVbyPriceSlow() -> Int {
        let predicate = NSPredicate(format: "specs.type == 'suv' && price <= 30000")
        let request = NSFetchRequest(entityName: "Car")
        request.predicate = predicate
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.executeFetchRequest(request) as! [Car]
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results.count
    }
    
    func getInventory(price: Int, condition: Int, type: String) -> [Car] {
        let pricePredicate = NSPredicate(format: "price <= %@", NSNumber(integer: price))
        let conditionPredicate = NSPredicate(format: "specs.conditionRating >= %@", NSNumber(integer: condition))
        
        var predicateArray = [pricePredicate, conditionPredicate]
        
        let carTypePredicate = type != "all" ? NSPredicate(format: "specs.type == %@", type) : NSPredicate()
        
        if carTypePredicate is NSComparisonPredicate {
            predicateArray.append(carTypePredicate)
        }
        
        let predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: predicateArray)
        
        let request = NSFetchRequest(entityName: "Car")
        request.predicate = predicate
        request.fetchBatchSize = 16
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.executeFetchRequest(request) as! [Car]
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    func getCarTypes() -> [String] {
        let request = NSFetchRequest(entityName: "Specification")
        
        var results: [Specification]
        var carTypes = ["all"]
        
        do {
            results = try managedObjectContext.executeFetchRequest(request) as! [Specification]
            for spec in results {
                if !carTypes.contains(spec.type!) {
                    carTypes.append(spec.type!)
                }
            }
        }
        catch {
            fatalError("Error getting list of car types from inventory")
        }
        
        return carTypes
    }
}
