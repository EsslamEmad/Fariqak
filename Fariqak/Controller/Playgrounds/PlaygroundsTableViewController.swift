//
//  PlaygroundsTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class PlaygroundsTableViewController: UITableViewController {

    var search = false
    var owners = false
    var playgrounds = [Playground]()
    var searchSentence = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if search{
            searchPlaygrounds()
        } else if owners{
            getMyPlaygrounds()
        }
        else{
            getAllPlaygrounds()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: Fetching Playgrounds
    func getAllPlaygrounds(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getPlaygrounds())
            }.done {
                self.playgrounds = try! JSONDecoder().decode([Playground].self, from: $0)
                self.tableView.reloadData()
            }.catch { error in
                self.showAlert(withMessage: NSLocalizedString("An error has occurred, Please try again later!", comment: ""))
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    func searchPlaygrounds(){
        SVProgressHUD.show()
        let searchRequest = SearchPlaygroundRequest(text: searchSentence, cityID: (APIAuth.auth.user?.cityID)!)
        
        firstly{
            return API.CallApi(APIRequests.searchPlaygrounds(searchRequest: searchRequest))
            }.done {
                self.playgrounds = try! JSONDecoder().decode([Playground].self, from: $0)
                self.tableView.reloadData()
            }.catch { error in
                self.showAlert(withMessage: NSLocalizedString("An error has occurred, Please try again later!", comment: ""))
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    func getMyPlaygrounds(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getOwnerPlaygrounds(ownerID: (APIAuth.auth.user?.id)!))
            }.done {
                self.playgrounds = try! JSONDecoder().decode([Playground].self, from: $0)
                self.tableView.reloadData()
            }.catch { error in
                self.showAlert(withMessage: NSLocalizedString("An error has occurred, Please try again later!", comment: ""))
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playgrounds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlaygroundTableViewCell
        var playground = playgrounds[indexPath.row]
        playground.photos?.append(playground.photo)
        if let imgurl = URL(string: playground.photos?[0] ?? ""){
            cell.playgroundImageView.kf.indicatorType = .activity
            cell.playgroundImageView.kf.setImage(with: imgurl)
        }
        cell.nameLabel.text = playground.title
        if let city = APIAuth.auth.cities.first(where: {$0.code == playground.cityID}){
            cell.addressLabel.text = city.name
        } else {
            cell.addressLabel.text = NSLocalizedString("Unknown City", comment: "")
        }
        cell.priceLabel.text = playground.price
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Playground", sender: playgrounds[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PlaygroundTableViewController
        destination.playground = sender as! Playground
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
