//
//  InventoryCollectionViewController.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 12/19/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "carCell"

class InventoryCollectionViewController: UICollectionViewController, ReportTableViewControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    var request: NSFetchRequest!
    var cars: [Car] = []
    var selectedCar: Car!
    var carService: CarService!
    
    @IBOutlet weak var carCollectionViewLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carService = CarService(managedObjectContext: managedObjectContext)
        cars = carService.getCarInventory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cars.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InventoryCollectionViewCell
    
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        let car = cars[indexPath.row]
        let image = UIImage(data: car.thumbnail!)
        cell.carImageView.image = image

        cell.carNameLabel.text = "\(car.year!) \(car.make!) \(car.model!)"
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let carPrice = formatter.stringFromNumber(car.price!)
        cell.carPriceLabel.text = carPrice
    
        return cell
    }
    
    /*override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCar = cars[indexPath.row]
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "carDetailSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let carDetailController = navController.topViewController as! CarDetailViewController
            
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            
            carDetailController.car = cars[indexPath!.row]
        }
        else if segue.identifier == "reportSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let reportController = navController.topViewController as! ReportTableViewController
            reportController.managedObjectContext = managedObjectContext
            
            reportController.delegate = self
        }
    }
    
    // MARK: ReportTableViewControllerDelegate protocol
    func updateCars(cars: [Car]) {
        self.cars = cars
        self.collectionView?.reloadData()
    }
    


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
