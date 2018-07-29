//
//  ProductTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 28/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import ImageSlideshow
import Cosmos
import SkyFloatingLabelTextField

class ProductTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, QuantityPickerControllerDelegate {
    
    var product: Product!
    var inputs = [InputSource]()
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var quantityTextInput: SkyFloatingLabelTextField!
    @IBOutlet weak var saveOrderButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        imageSlide.setImageInputs(inputs)
        priceLabel.text = "\(product.price) " + NSLocalizedString("S.R", comment: "")
        nameLabel.text = product.name
        descriptionLabel.text = NSLocalizedString("Description", comment: "") + ":\n\n\(product.details)"
        ratingView.rating = Double(product.rate) ?? 0.0
        ratingView.settings.fillMode = .precise
        imageSlide.slideshowInterval = 2.0
        imageSlide.contentScaleMode = .scaleAspectFill
        imageSlide.clipsToBounds = true
        imageSlide.zoomEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnImageSlide))
        imageSlide.addGestureRecognizer(gestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressAddToCart(_ sender: Any) {
        
        
        
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuantityPicker") as! QuantityPickerViewController
        popController.delegate = self
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        popController.popoverPresentationController?.sourceView = self.saveOrderButton
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: saveOrderButton.frame.size.width, height: saveOrderButton.frame.size.height)
        
        
        popController.popoverPresentationController?.delegate = self
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
        
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        // Dim the view behind the popover
        popoverPresentationController.containerView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func addToCart(quantity: String){
        var orderItem = OrderItem()
        orderItem.productID = product.code
        orderItem.quantity = quantity
        APIAuth.auth.shoppingCart.append(orderItem)
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Your order has been added to the shopping cart successfuly.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            self.performSegue(withIdentifier: "Exit", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchPhotos(){
        for photo in product.photos{
            if let imgurl = URL(string: photo){
                inputs.append(KingfisherSource(url: imgurl))
            }
        }
        
    }

    
    func unwindToContainerVCWithSegue(_ sender: UIStoryboardSegue){
        let source = sender.source as! QuantityPickerViewController
        addToCart(quantity: source.quantity)
    }
   
    
   
    @objc func didTapOnImageSlide() {
        imageSlide.presentFullScreenController(from: self)
    }
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
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
protocol QuantityPickerControllerDelegate{
    func addToCart(quantity: String)
}
