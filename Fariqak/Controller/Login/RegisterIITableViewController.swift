//
//  RegisterIITableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 27/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit
import SkyFloatingLabelTextField
import SVProgressHUD

class RegisterIITableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var user = User()
    var email: String!
    var name: String!
    var password: String!
    //var type: String!
    //var phone: String!
    //var cityID: String!
    var cities = [City]()
    let color1: UIColor! = UIColor(red: 0.0, green: 150.0/255.0, blue: 0.0, alpha: 1.0)
    let color2: UIColor! = UIColor.lightGray
    
    @IBOutlet var imagePicker: UIImageView!
    @IBOutlet var playerButton: UIButton!
    @IBOutlet var ownerButton: UIButton!
    @IBOutlet var nameLabel: SkyFloatingLabelTextField!
    @IBOutlet var phoneLabel: SkyFloatingLabelTextField!
    @IBOutlet var cityTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //subscribeToKeyboardNotifications()
        view.endEditing(false)
        imagePicker.layer.cornerRadius = 64.0
        initializeToolbar()
        initializeCityPicker()
        nameLabel.text = name
        user.type = "1"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Register(_ sender: Any){
        
        guard let name = nameLabel.text, nameLabel.text != "" else{
            self.showAlert(withMessage: NSLocalizedString("Enter your full name.", comment: ""))
            return
        }
        guard let phone = phoneLabel.text, phone != "" else{
            self.showAlert(withMessage: NSLocalizedString("Enter your phone number.", comment: ""))
            return
        }
        guard user.cityID != "" else {
            self.showAlert(withMessage: NSLocalizedString("Choose your city.", comment: ""))
            return
        }
        
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
            if let error = error{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: error.localizedDescription)
                return
            }
            
            self.user.username = name
            self.user.firebaseID = (user?.uid)!
            self.user.email = self.email
            self.user.phone =  phone
            
            if let image = self.imagePicker.image{
                firstly{
                    return API.CallApi(APIRequests.upload(photo: image))
                    } .done{
                        let response = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                        self.user.photos = response.image!
                    
                    }.catch{_ in
                        self.showAlert(withMessage: NSLocalizedString("Could not upload the photo, please try again later!", comment: ""))
                    } .finally{
                        self.RegisterRequest()
                }
            } else {
                self.RegisterRequest()
            }
            
        }
    }
    func RegisterRequest(){
        firstly{ () -> Promise<Data> in
            
            return API.CallApi(APIRequests.register(user: self.user))
            
            } .done{ [weak self] resp -> Void in
                
                self?.user = try! JSONDecoder().decode(User.self, from: resp)
                
                self?.performMainSegue()
                
            } .catch{ [weak self] error in
                
                self?.showAlert(withMessage: error.localizedDescription)
                self?.performMainSegue()
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        APIAuth.auth.user = self.user
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    

   /* @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
        else{
            self.showAlert(withMessage: "Application can not access photo library.")
        }
    }*/
    
    
    // Mark: Image Picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePicker.image = selectedImage
            imagePicker.contentMode = .scaleAspectFit
            imagePicker.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                SVProgressHUD.show()
                present(picker, animated: true, completion: {SVProgressHUD.dismiss()})
            }
            else{
                self.showAlert(withMessage: NSLocalizedString("Application can not access photo library.", comment: ""))
            }
        }
    }
    
    
    
    // Mark: Type Picker
    
    @IBAction func PlayerButton (_ sender: Any?){
        user.type = "1"
        playerButton.backgroundColor = color1
        ownerButton.backgroundColor = color2
        
    }
    @IBAction func OwnerButton (_ sender: Any?){
        user.type = "3"
        playerButton.backgroundColor = color2
        ownerButton.backgroundColor = color1
    }
    
    
    
    // Mark: Cities Picker
    
    private let cityPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    
    private func initializeCityPicker() {
        cityPicker.delegate = self
        cityTextField.inputView = cityPicker
        cityTextField.inputAccessoryView = inputAccessoryBar
    }
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
    }
    
    //MARK: - Picker Helpers
    private func fetchCities() {
        firstly { () -> Promise<Data> in
            
            return API.CallApi(APIRequests.getCities())
            }.done { [weak self] resp -> Void in
                let decoder = JSONDecoder()
                self?.cities = try! decoder.decode([City].self, from: resp)
            }.ensure {
                
            }.catch { [weak self] (error) in
                self?.showAlert(withMessage: error.localizedDescription)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        cityTextField.text = cities[cityPicker.selectedRow(inComponent: 0)].name
        user.cityID = cities[cityPicker.selectedRow(inComponent: 0)].code
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

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
