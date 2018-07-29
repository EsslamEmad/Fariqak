//
//  OrderTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 9/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class OrderTableViewController: UITableViewController {

    var order = Order()
    var products = [Product]()
    var rowNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = order.id
        var completed = 0
        for i in 0 ... order.products.count - 1{
            SVProgressHUD.show()
            products = Array(repeating: Product(), count: order.products.count)
            firstly{
                return API.CallApi(APIRequests.getProductBy(id: order.products[i].productID))
                }.done {
                    self.products[i] = try! JSONDecoder().decode(Product.self, from: $0)
                    
                } .catch{ error in
                    self.showAlert(withMessage: NSLocalizedString("An error has occurred, Please try again later!", comment: ""))
                }.finally {
                    
                    
                    completed += 1
                    if completed == self.order.products.count{
                        self.rowNumber = completed + 1
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowNumber
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Order Cell", for: indexPath) as! OrderTableViewCell
            cell.orderNumberLabel.text = NSLocalizedString("Order No.: ", comment: "") + "\(order.id)"
            cell.priceLabel.text = NSLocalizedString("Price:", comment: "") + " \(order.totalPrice) " + NSLocalizedString("S.R", comment: "")
            cell.detailsLabel.text = NSLocalizedString("Details:", comment: "") + " \(order.details)"
            cell.addressLabel.text = NSLocalizedString("Address:", comment: "") + " \(order.address)"
            cell.statusLabel.text = NSLocalizedString("Status: ", comment: "") + "\(order.state)"
            return cell
        }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell") as! ShoppingCartTableViewCell
        let product = products[indexPath.row - 1]
        if let imgurl = URL(string: product.photos[0]){
            cell.productImage.kf.indicatorType = .activity
            cell.productImage.kf.setImage(with: imgurl)
        }
        cell.productName.text = product.name
        cell.productPrice.text = "\(Int(product.price)! * Int(order.products[indexPath.row - 1].quantity)!) " + NSLocalizedString("S.R", comment: "")
        return cell
        }
    }
    

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
