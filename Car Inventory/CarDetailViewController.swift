//
//  CarDetailViewController.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 12/19/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit

class CarDetailViewController: UIViewController {

    var car: Car!
    var specs: Specification!
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var carHpLabel: UILabel!
    @IBOutlet weak var carMpgLabel: UILabel!
    @IBOutlet weak var carSafetyLabel: UILabel!
    @IBOutlet weak var carConditionLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        let carImage = car.carImage!
        carImageView.image = UIImage(data: carImage.image!)
        carNameLabel.text = "\(car.year!) \(car.make!) \(car.model!)"
        carPriceLabel.text = formatter.stringFromNumber(car.price!)
        
        specs = car.specs
        carHpLabel.text = String(specs.horsepower!)
        carMpgLabel.text = String(specs.avgFuel!)
        carSafetyLabel.text = String(specs.safetyRating!)
        carConditionLabel.text = String(specs.conditionRating!)
        carTypeLabel.text = specs.type
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    */

}
