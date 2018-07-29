//
//  AddPlaygroundTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 16/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleMaps
import SVProgressHUD
import PromiseKit

class AddPlaygroundTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GMSMapViewDelegate {

    var playground = Playground()
    var images = [UIImage]()
    var isLocationAdded = false
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var priceTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var addButton: FariqakButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        initializeToolbar()
        initializeCityPicker()
        
        //Setting Map Camera
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12.0)
        mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func didPressAdd(_ sender: Any) {
        guard let name = nameTextField.text , name != "", let price = priceTextField.text, price != "", ImagePicked, isLocationAdded, playground.cityID != "", let description = descriptionTextField.text, description != "" else{
            self.showAlert(withMessage: NSLocalizedString("Please complete all the fields", comment: ""))
            return
        }
        SVProgressHUD.show()
        SVProgressHUD.setStatus("Uploading your playground photos..")
        addButton.isEnabled = false
        var completed = 0
        var imageurls = [String]()
        playground.owner = APIAuth.auth.user?.id
        playground.title = name
        playground.price = price
        playground.details = description
        for image in images{
            firstly{
                return API.CallApi(APIRequests.upload(photo: image))
                }.done {
                    let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                    imageurls.append(resp.thumb!)
                }.catch { error in
                }.finally {
                    completed += 1
                    if completed == self.images.count{
                        self.playground.photos = imageurls
                        self.playground.photo = imageurls[0]
                        self.addRequest()
                    }
            }
        }
    }
    
    func addRequest() {
            firstly{
            return API.CallApi(APIRequests.addPlayground(playground: playground))
            }.done { resp in
                let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Your new playground has been added succefully.", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    SVProgressHUD.dismiss()
                    self.performMainSegue()
                }))
                self.present(alert, animated: true, completion: nil)
            }.catch { error in
                SVProgressHUD.dismiss()
                self.addButton.isEnabled = true

                self.showAlert(withMessage: error.localizedDescription)
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
    
    //Mark: Add Location
    
    @IBAction func didPressOnMap(_ sender: Any) {
        performSegue(withIdentifier: "Show Map", sender: nil)
    }
    
    @IBAction func unwindFromMapView(_ sender: UIStoryboardSegue) {
        let source = sender.source as! AddLocationMapViewController
        if let marker = source.mapView.selectedMarker {
            marker.map = mapView
            mapView.camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 12.0)
            playground.lat = String(marker.position.latitude)
            playground.lng = String(marker.position.longitude)
            isLocationAdded = true
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        didPressOnMap(true)
    }
    
    
    //Mark: Images Picker
    
    @IBAction func didPressOnImage(_ sender: Any) {
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
            images.append(selectedImage)
            ImagePicked = true
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    
    // Mark: Cities Picker
    
    private let cityPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    var cities = APIAuth.auth.cities
    
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities![row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        cityTextField.text = cities![cityPicker.selectedRow(inComponent: 0)].name
        playground.cityID = cities![cityPicker.selectedRow(inComponent: 0)].code
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }

}
