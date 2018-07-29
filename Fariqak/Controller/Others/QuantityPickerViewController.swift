//
//  QuantityPickerViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class QuantityPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var product: Product!
    var quantity: String!
    var delegate: QuantityPickerControllerDelegate?
    var hoursDelegte: HoursPickerControllerDelegate?
    var startingHour = false
    var endingHour = false
    var endingRangeInitiator: Int?
    var startingRangeFinisher: Int?
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        if startingHour{
            titleLabel.text = NSLocalizedString("Choose the starting hour", comment: "")
        }
        else if endingHour{
            titleLabel.text = NSLocalizedString("Choose the ending hour", comment: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressDone(_ sender: Any){
        /*let productVC = self.presentingViewController as! ProductTableViewController
        productVC.addToCart(quantity: String(picker.selectedRow(inComponent: 0) + 1))
        self.dismiss(animated: true, completion: nil)*/
        //quantity = String(picker.selectedRow(inComponent: 0) + 1)
        //performSegue(withIdentifier: "Exit", sender: String(picker.selectedRow(inComponent: 0) + 1))
        if delegate != nil{
            self.dismiss(animated: true, completion: nil)
            delegate?.addToCart(quantity: String(picker.selectedRow(inComponent: 0) + 1))
        } else if hoursDelegte != nil {
            self.dismiss(animated: true, completion: nil)
            if startingHour{
                hoursDelegte?.Timing(startingHour: String(picker.selectedRow(inComponent: 0) + 1), endingHour: nil)
            } else if endingHour{
                hoursDelegte?.Timing(startingHour: nil, endingHour: String(picker.selectedRow(inComponent: 0) + endingRangeInitiator! + 1))
            }
        }
    }
    
    @IBAction func didPressCancel(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if startingHour{
            return startingRangeFinisher! - 1
        } else if endingHour{
            return 24 - endingRangeInitiator!
        }
        return 5
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if startingHour{
            return String(row + 1)
        } else if endingHour{
            return String(row + endingRangeInitiator! + 1)
        }
        return String(row + 1)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
