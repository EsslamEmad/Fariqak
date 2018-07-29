//
//  OrdersTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 9/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class OrdersTableViewController: UITableViewController {

    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetching Current User Orders
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getOrdersOfUser(userID: (APIAuth.auth.user?.id)!))
            //return API.CallApi(APIRequests.getOrdersOfUser(userID: "99"))
            }.done{
                self.orders = try! JSONDecoder().decode([Order].self, from: $0)
                self.tableView.reloadData()
            }.catch{ error in
                self.showAlert(withMessage: NSLocalizedString("Could not fetch your orders, Please try again later!", comment: ""))
            }.finally {
                SVProgressHUD.dismiss()
        }
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
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order Cell", for: indexPath) as! OrderTableViewCell
        cell.orderNumberLabel.text = NSLocalizedString("Order No.: ", comment: "") + "\(orders[indexPath.row].id)"
        cell.priceLabel.text = NSLocalizedString("Price:", comment: "") + " \(orders[indexPath.row].totalPrice) " + NSLocalizedString("S.R", comment: "")
        cell.detailsLabel.text = NSLocalizedString("Details:", comment: "") + " \(orders[indexPath.row].details)"
        cell.addressLabel.text = NSLocalizedString("Address:", comment: "") + " \(orders[indexPath.row].address)"
        var status = ""
        switch orders[indexPath.row].state{
        case "0": status = NSLocalizedString("Operating..", comment: "")
        case "1": status = NSLocalizedString("Delivered.", comment: "")
        case "2": status = NSLocalizedString("Declined.", comment: "")
        default: status = NSLocalizedString("In progress..", comment: "")
        }
        cell.statusLabel.text = NSLocalizedString("Status: ", comment: "") + status
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Order", sender: orders[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! OrderTableViewController
        destination.order = sender as! Order
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
