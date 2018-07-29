//
//  ShoppingCartViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 7/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import Kingfisher

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cart = APIAuth.auth.shoppingCart
    var totalPrice: Int = 0
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: TableView Protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cart?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ShoppingCartTableViewCell
        var product: Product!
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getProductBy(id: cart![indexPath.row].productID))
            }.done{
                product = try! JSONDecoder().decode(Product.self, from: $0)
                if let imgurl = URL(string: product.photos[0]){
                    cell.productImage.kf.indicatorType = .activity
                    cell.productImage.kf.setImage(with: imgurl)
                }
                cell.productName.text = product.name
                let productPrice = Int(product.price)! * Int(self.cart![indexPath.row].quantity)!
                cell.productPrice.text = "\(productPrice) " + NSLocalizedString("S.R", comment: "")
                self.totalPrice += productPrice
                SVProgressHUD.dismiss()
            }.catch{ error in
                cell.frame.size.height = 0
                self.showAlert(withMessage: NSLocalizedString("Could not retrieve your products, Please try again later!", comment: ""))
                self.saveButton.isEnabled = false
            }.finally {
                return cell
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SaveOrderTableViewController
        destination.order.totalPrice = String(totalPrice)
        
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
