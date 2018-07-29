//
//  EditProfileTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 18/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SkyFloatingLabelTextField
import Firebase
import SVProgressHUD

class EditProfileTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var user = APIAuth.auth.user!
    
    
    
    
    var cities = [City]()
    
    
    @IBOutlet var imagePicker: UIImageView!
    @IBOutlet var nameLabel: SkyFloatingLabelTextField!
    @IBOutlet var phoneLabel: SkyFloatingLabelTextField!
    @IBOutlet var cityTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        view.endEditing(false)
        imagePicker.layer.cornerRadius = 64.0
        initializeToolbar()
        initializeCityPicker()
        nameLabel.text = user.username
        phoneLabel.text = user.phone
        if let found = cities.first(where: {$0.code == user.cityID}) {
            cityTextField.text = found.name
        }
        if let imgurl = URL(string: user.photos){
            imagePicker.kf.indicatorType = .activity
            imagePicker.kf.setImage(with: imgurl, options: [.transition(.fade(0.2))])
            
        }

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCities()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Update(_ sender: Any){
        
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
            self.user.username = name
            self.user.phone =  phone
            
            if ImagePicked{
                firstly{
                    return API.CallApi(APIRequests.upload(photo: self.imagePicker.image!))
                    } .done{
                        let response = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                        self.user.photos = response.image!                        
                    }.catch{_ in
                        self.showAlert(withMessage: NSLocalizedString("Could not upload the photo, please try again later!", comment: ""))
                    } .finally{
                        self.UpdateRequest()
                }
            } else {
                self.UpdateRequest()
            }
            
        
    }
    func UpdateRequest(){
        firstly{ () -> Promise<Data> in
            
            return API.CallApi(APIRequests.updateUser(user: self.user))
            
            } .done{ [weak self] resp -> Void in
                self?.user = try! JSONDecoder().decode(User.self, from: resp)
                APIAuth.auth.user = self?.user
                self?.performSegue(withIdentifier: "unwindToProfile", sender: self)
                
            } .catch{ [weak self] error in
                
                self?.showAlert(withMessage: error.localizedDescription)
        }
    }
    
    
    
    
    
    
    // Mark: Image Picker
    var ImagePicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePicker.image = selectedImage
            imagePicker.contentMode = .scaleAspectFit
            imagePicker.clipsToBounds = true
            ImagePicked = true
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
                present(picker, animated: true, completion: nil)
            }
            else{
                self.showAlert(withMessage: NSLocalizedString("Application can not access photo library.", comment: ""))
            }
        }
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
            SVProgressHUD.show()
            return API.CallApi(APIRequests.getCities())
            }.done { [weak self] resp -> Void in
                let decoder = JSONDecoder()
                self?.cities = try! decoder.decode([City].self, from: resp)
                if let found = self?.cities.first(where: {$0.code == self?.user.cityID}) {
                    self?.cityTextField.text = found.name
                }
            }.ensure {
                SVProgressHUD.dismiss()
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
    
    
}
