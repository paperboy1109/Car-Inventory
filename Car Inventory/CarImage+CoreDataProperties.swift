//
//  CarImage+CoreDataProperties.swift
//  Car Inventory
//
//  Created by Daniel J Janiak on 7/18/16.
//  Copyright © 2016 PFI. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CarImage {

    @NSManaged var image: NSData?
    @NSManaged var cars: Car?

}
