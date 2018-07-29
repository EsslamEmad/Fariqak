//
//  ReservingPlaygroundTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 14/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import PromiseKit

class ReservingPlaygroundTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, HoursPickerControllerDelegate, DatePickerControllerDelegate {
    
    

    var reservation = Reservation()
    let color1: UIColor! = UIColor(red: 0.0, green: 150.0/255.0, blue: 0.0, alpha: 1.0)
    let color2: UIColor! = UIColor.lightGray
    var cash = true
    var startingHour: String?
    var endingHour: String?
    var date: String?
    var playgroundID: String!
    var price: Int!
    var ownerID: String!
    
    @IBOutlet weak var dateButton: FariqakButton!
    @IBOutlet weak var startingHourButton: FariqakButton!
    @IBOutlet weak var endingHourButton: FariqakButton!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bankTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reserveButton: FariqakButton!
    @IBOutlet var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didPressCash(true)
        priceLabel.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressReserve(_ sender: Any) {
        if !cash{
            guard nameTextField.text != "", bankTextField.text != "", ImagePicked else{
                self.showAlert(withMessage: NSLocalizedString("Please complete all the fields", comment: ""))
                return
            }
            reservation.name = nameTextField.text!
            reservation.bank = bankTextField.text!
        }
        guard let SH = startingHour, let EH = endingHour, let date = date else{
            self.showAlert(withMessage: NSLocalizedString("Please complete all the fields in order to submit your reservation", comment: ""))
            return
        }
        reservation.fromHour = SH
        reservation.toHour = EH
        reservation.date = date
        reservation.teamLeaderID = (APIAuth.auth.user?.id)!
        reservation.playgroundID = playgroundID
        
        SVProgressHUD.show()
        reserveButton.isEnabled = false
        if !cash{
            if let image = self.imageView.image{
                firstly{
                    return API.CallApi(APIRequests.upload(photo: image))
                    }.done {
                        let response = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                        self.reservation.photo = response.image!
                        self.reserveRequest()
                    }.catch{ error in
                        self.showAlert(withMessage: NSLocalizedString("Could not upload the photo, please try again later!", comment: ""))
                        
                    }.finally {
                        self.reserveButton.isEnabled = true
                        SVProgressHUD.dismiss()
                }
            }
            else{
                self.showAlert(withMessage: NSLocalizedString("Could not upload the photo, please try again later!", comment: ""))
                self.reserveButton.isEnabled = true
                SVProgressHUD.dismiss()
            }
            return
        }
        
        reserveRequest()
    }
    func reserveRequest(){
        firstly{
            return API.CallApi(APIRequests.addReservation(reservation: reservation))
            }.done { resp in
                let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Your reservation has been added succefully.", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "Exit", sender: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                var n = UserNotification()
                n.title = "New Reservation حجز جديد"
                n.userID = self.ownerID
                firstly{
                    return API.CallApi(APIRequests.sendNotification(notification: n))
                    }.done { resp in } .catch { error in }
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                self.reserveButton.isEnabled = true
                SVProgressHUD.dismiss()
                
        }
        
        
    }
    
    @IBAction func didPressDate(_ sender: Any) {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerViewController
        popController.delegate = self
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.sourceView = self.dateButton
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: dateButton.frame.size.width, height: dateButton.frame.size.height)
        popController.popoverPresentationController?.delegate = self
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func didPressStartingHour(_ sender: Any) {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuantityPicker") as! QuantityPickerViewController
        popController.hoursDelegte = self
        popController.startingHour = true
        if endingHour != nil{ popController.startingRangeFinisher = Int(endingHour!) }else { popController.startingRangeFinisher = 24}
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.sourceView = self.startingHourButton
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: startingHourButton.frame.size.width, height: startingHourButton.frame.size.height)
        popController.popoverPresentationController?.delegate = self
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func didPressEndingHour(_ sender: Any) {
        if let SH = startingHour{
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuantityPicker") as! QuantityPickerViewController
        popController.hoursDelegte = self
            popController.endingHour = true
            popController.endingRangeInitiator = Int(SH)!
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.sourceView = self.endingHourButton
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: endingHourButton.frame.size.width, height: endingHourButton.frame.size.height)
        popController.popoverPresentationController?.delegate = self
        self.present(popController, animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressCash(_ sender: Any) {
        reservation.payment = "1"
        cashButton.backgroundColor = color1
        bankButton.backgroundColor = color2
        cash = true
        tableView.reloadData()
    }
    
    @IBAction func didPressBank(_ sender: Any) {
        reservation.payment = "2"
        cashButton.backgroundColor = color2
        bankButton.backgroundColor = color1
        cash = false
        tableView.reloadData()
    }
    
    
    
    func Timing(startingHour: String?, endingHour: String?) {
        if let SH = startingHour{
            self.startingHour = SH
            startingHourButton.setTitle("\(SH):00", for: .normal)
        } else if let EH = endingHour{
            self.endingHour = EH
            endingHourButton.setTitle("\(EH):00", for: .normal)
        }
        if self.endingHour != nil{
            priceLabel.text = "\((Int(self.endingHour!)! - Int(self.startingHour!)!) * price) " + NSLocalizedString("S.R", comment: "")
        }
    }
    
    func Dating(date: String){
        self.date = date
        dateButton.setTitle(date, for: .normal)
    }
    
    //Mark: Popover Protocol Functions
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        // Dim the view behind the popover
        popoverPresentationController.containerView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Mark: Image Picker
    @IBAction func PickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            SVProgressHUD.show()
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
        else{
            self.showAlert(withMessage: NSLocalizedString("Application can not access photo library.", comment: ""))
        }
    }
    var ImagePicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = selectedImage
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 || indexPath.row == 5{
            if cash {
                return 0
            }
            else{
                return 94
            }
        }
        if indexPath.row == 6{
            if cash {
                return 0
            }
            else{
                return 187
            }
        }
        return 94
    }
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol HoursPickerControllerDelegate{
    func Timing(startingHour: String?, endingHour: String?)
}
protocol DatePickerControllerDelegate {
    func Dating(date: String)
}
