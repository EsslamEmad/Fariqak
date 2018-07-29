//
//  MyTeamsTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import Kingfisher

class MyTeamsTableViewController: UITableViewController {

    var teams = [Team]()
    var allTeams = false
    var playerTeams = false
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if allTeams{
            self.title = NSLocalizedString("All Teams", comment: "")
            fetchAllTeams()
        } else if playerTeams{
            fetchPlayerTeams()
            self.title = "\(user.username)" + NSLocalizedString("'s Teams", comment: "")
        } else {
            fetchMyTeams()
        }
        tableView.rowHeight = 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchMyTeams (){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUserTeams(userID: (APIAuth.auth.user?.id)!))
            } .done {
                self.teams = try! JSONDecoder().decode([Team].self, from: $0)
                self.tableView.reloadData()
            } .catch { error in
                print(error.localizedDescription)
            } .finally {
                SVProgressHUD.dismiss()
        }
    }
    func fetchAllTeams(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getTeams())
            } .done {
                self.teams = try! JSONDecoder().decode([Team].self, from: $0)
                self.tableView.reloadData()
            } .catch { error in
                print(error.localizedDescription)
            } .finally {
                SVProgressHUD.dismiss()
        }
    }
    func fetchPlayerTeams(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUserTeams(userID: user.id))
            } .done {
                self.teams = try! JSONDecoder().decode([Team].self, from: $0)
                self.tableView.reloadData()
            } .catch { error in
                print(error.localizedDescription)
            } .finally {
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
        return teams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTeamTableViewCell

        cell.teamNameLabel.text = teams[indexPath.row].name
        if let logo = teams[indexPath.row].logo, logo != ""{
            if let imgurl = URL(string: logo){
                cell.teamLogo.kf.indicatorType = .activity
                cell.teamLogo.kf.setImage(with: imgurl)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TeamSegue", sender: teams[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamSegue"{
            let destination = segue.destination as! TeamViewController
            destination.team = sender as! Team
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
