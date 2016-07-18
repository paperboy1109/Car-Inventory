//
//  AppDelegate.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 12/19/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit
import CoreData
import ImageIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let coreData = CoreData()
        
        let navController = self.window?.rootViewController as! UINavigationController
        let inventoryController = navController.topViewController as! InventoryCollectionViewController
        inventoryController.managedObjectContext = coreData.managedObjectContext
        
        //deleteRecords()
        checkDataStore()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func checkDataStore() {
        let coreData = CoreData()
        let request = NSFetchRequest(entityName: "Car")
        
        // let carsCount = coreData.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
        let carsCount = coreData.managedObjectContext.countForFetchRequest(request, error: nil)
        print("Total cars: \(carsCount)")
        
        if carsCount == 0 {
            uploadSampleData()
        }
    }
    
    func uploadSampleData() {
        let coreData = CoreData()
        
        let url = NSBundle.mainBundle().URLForResource("cars", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            let jsonArray = jsonResult.valueForKey("inventory") as! NSArray
            
            for json in jsonArray {
                let car = NSEntityDescription.insertNewObjectForEntityForName("Car", inManagedObjectContext: coreData.managedObjectContext) as! Car
                
                car.make = json["make"] as? String
                car.model = json["model"] as? String
                car.year = (json["year"] as? NSString)!.integerValue
                car.price = (json["values"] as! NSDictionary)["price"] as? NSNumber
                
                let imageName = String(car.year!.integerValue) + car.make! + car.model! + ".jpg"
                let image = UIImage(named: imageName)
                let carData = UIImageJPEGRepresentation(image!, 1)
                car.thumbnail = scaleImage(carData!)
                
                let carImage = NSEntityDescription.insertNewObjectForEntityForName("CarImage", inManagedObjectContext: coreData.managedObjectContext) as! CarImage
                carImage.image = carData
                // note that the carImage property of car referrs to a relationship, not an attribute 
                car.carImage = carImage
                
                let specs = NSEntityDescription.insertNewObjectForEntityForName("Specification", inManagedObjectContext: coreData.managedObjectContext) as! Specification
                specs.conditionRating = (json["values"] as! NSDictionary)["condition"] as? NSNumber
                specs.avgFuel = (json["values"] as! NSDictionary)["fuel_eff"] as? NSNumber
                specs.horsepower = (json["values"] as! NSDictionary)["horsepower"] as? NSNumber
                specs.type = json["type"] as? String
                
                var safetyRating = (json["values"] as! NSDictionary)["safety"] as? NSString
                if safetyRating == "NA" {
                    safetyRating = "10"
                }
                specs.safetyRating = safetyRating!.integerValue
                
                car.specs = specs
            }
            
            coreData.saveContext()
            
            let request = NSFetchRequest(entityName: "Car")
            // let carsCount = coreData.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
            let carsCount = coreData.managedObjectContext.countForFetchRequest(request, error: nil)
            print("Total cars: \(carsCount)")
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
    
    func scaleImage(imageData: NSData) -> NSData {
        // let carCFData = CFDataCreate(CFAllocator!.init(), UnsafePointer<UInt8>(imageData.bytes), imageData.length)
        // "Use string literal instead"
        let carCFData = CFDataCreate(CFAllocator!.init(), UnsafePointer<UInt8>(imageData.bytes), imageData.length)
        let imageSource = CGImageSourceCreateWithData(carCFData, nil)
        let options: [NSString: NSObject] = [kCGImageSourceThumbnailMaxPixelSize: max(0, 200)/1.0, kCGImageSourceCreateThumbnailFromImageAlways: true]
        let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource!, 0, options).flatMap { UIImage(CGImage: $0) }
        
        let scaleImageData = UIImageJPEGRepresentation(scaledImage!, 1)
        
        return scaleImageData!
    }
    
    func deleteRecords() {
        let coreData = CoreData()
        let request = NSFetchRequest(entityName: "Car")
        
        do {
            let carResults = try coreData.managedObjectContext.executeFetchRequest(request) as! [Car]
            for car in carResults {
                coreData.managedObjectContext.deleteObject(car)
            }
            
            coreData.saveContext()
            
            let carsCount = coreData.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
            print("Total cars after clean up: \(carsCount)")
        }
        catch {
            fatalError("Error deleting objects")
        }
    }
}

