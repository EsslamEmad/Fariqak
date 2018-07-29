//
//  SaveOrderTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 8/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD

class SaveOrderTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var order = Order()
    let color1: UIColor! = UIColor(red: 0.0, green: 150.0/255.0, blue: 0.0, alpha: 1.0)
    let color2: UIColor! = UIColor.lightGray
    var cash = true
    
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var detailsTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bankTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var bankCell: UITableViewCell!
    @IBOutlet weak var imageCell: UITableViewCell!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        didPressCash(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressSave(_ sender: Any) {
        guard let address = addressTextField.text, address != "", let details = detailsTextField.text, details != "" else{
            self.showAlert(withMessage: NSLocalizedString("Please complete all the fields", comment: ""))
            return
        }
        if !cash{
            guard let name = nameTextField.text, name != "", let bank = bankTextField.text, bank != "", ImagePicked else{
                self.showAlert(withMessage: NSLocalizedString("Please complete all the fields", comment: ""))
                return
            }
            order.bank = bank
            order.name = name
        }
        order.address = address
        order.details = details
        order.userID = (APIAuth.auth.user?.id)!
        order.products = APIAuth.auth.shoppingCart
        order.payway = order.payment
        SVProgressHUD.show()
        saveButton.isEnabled = false
        if !cash{
            if let image = self.imageView.image{
                firstly{
                    return API.CallApi(APIRequests.upload(photo: image))
                    }.done {
                        let response = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                        self.order.photo = response.image!
                        self.saveRequest()
                    }.catch{ error in
                        self.showAlert(withMessage: NSLocalizedString("Could not upload the photo, please try again later!", comment: ""))
                        
                    }.finally {
                        self.saveButton.isEnabled = true
                        SVProgressHUD.dismiss()
                }
            }
            else{
                self.showAlert(withMessage: NSLocalizedString("Could not upload the photo, please try again later!", comment: ""))
                self.saveButton.isEnabled = true
                SVProgressHUD.dismiss()
            }
            return
        }
        
        saveRequest()
    }
    
    func saveRequest(){
        firstly{
            return API.CallApi(APIRequests.saveOrder(order: order))
            }.done { resp in
                self.showAlert(error: false, withMessage: NSLocalizedString("Your order has been saved succefully, you can track your order from Orders page.", comment: ""), completion: nil)
                APIAuth.auth.shoppingCart = [OrderItem]()
                self.performMainSegue()
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                self.saveButton.isEnabled = true
                SVProgressHUD.dismiss()
                
        }
    }
    func performMainSegue(){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    @IBAction func didPressCash(_ sender: Any) {
        order.payment = "1"
        cashButton.backgroundColor = color1
        bankButton.backgroundColor = color2
        cash = true
        tableView.reloadData()
    }
    @IBAction func didPressBank(_ sender: Any) {
        order.payment = "2"
        cashButton.backgroundColor = color2
        bankButton.backgroundColor = color1
        cash = false
        tableView.reloadData()
    }
    
    //Image Picker
    
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
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
        if indexPath.row == 3 || indexPath.row == 4{
            if cash {
                return 0
            }
            else{
                return 94
            }
        }
        if indexPath.row == 5{
            if cash {
                return 0
            }
            else{
                return 187
            }
        }
        return 94
    }

    /*override func numberOfSections(in tableView: UITableView) -> Int {
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
