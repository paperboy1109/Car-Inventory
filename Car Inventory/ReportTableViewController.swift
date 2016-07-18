//
//  ReportTableViewController.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 12/21/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit
import CoreData

protocol ReportTableViewControllerDelegate {
    func updateCars(cars: [Car])
}

class ReportTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    var delegate: ReportTableViewControllerDelegate!
    var carService: CarService!
    var pickerDatasource = []
    var selectedCarType = "all"
    
    @IBOutlet weak var totalCarLabel: UILabel!
    @IBOutlet weak var suvUnder30Label: UILabel!
    @IBOutlet weak var priceMaxField: UITextField!
    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        carService = CarService(managedObjectContext: managedObjectContext)
        let totalCar = carService.getTotalCarInInventorySlow()
        let totalSuvUnder30K = carService.getTotalSUVbyPriceSlow()
        
        pickerDatasource = carService.getCarTypes()
        
        totalCarLabel.text = String(totalCar)
        suvUnder30Label.text = String(totalSuvUnder30K)
        priceMaxField.text = "30000"
        conditionTextField.text = "9"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Picker View delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDatasource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDatasource[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCarType = pickerDatasource[row] as! String
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 3
        }
        return 0
    }
    
    @IBAction func setFilterAction(sender: UIBarButtonItem) {
        let cars = carService.getInventory(Int(priceMaxField.text!)!, condition: Int(conditionTextField.text!)!, type: selectedCarType)
        
        delegate.updateCars(cars)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        let cars = carService.getCarInventory()
        
        delegate.updateCars(cars)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
