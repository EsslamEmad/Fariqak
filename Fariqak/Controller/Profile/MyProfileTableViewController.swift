//
//  MyProfileTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Kingfisher
import PromiseKit

class MyProfileTableViewController: UITableViewController {

    var user : User!
    var teams = [Team]()
    var myProfile = true
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var chatButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if !myProfile, user.id == APIAuth.auth.user?.id{
            myProfile = true
        }
        if myProfile{
            self.user = APIAuth.auth.user
            chatButton.alpha = 0
        } else {
            editButton.isEnabled = false
            editButton.title = ""
            chatButton.layer.cornerRadius = chatButton.bounds.width / 2.0
            self.title = self.user.username
        }
        
        
        if let imgurl = URL(string: user.photos){
            photo.kf.indicatorType = .activity
            photo.kf.setImage(with: imgurl, options: [.transition(.fade(0.2))])
        }
        nameLabel.text = user.username
        phoneLabel.text = user.phone
        if user.cityID != "" {
            firstly{
                return API.CallApi(APIRequests.getCities())
                } .done{
                    let cities = try! JSONDecoder().decode([City].self, from: $0)
                    for city in cities{
                        if self.user.cityID == city.code{
                            self.cityLabel.text = city.name
                            return
                        }
                    }
                    
                } .catch {
                    print($0.localizedDescription)
            }
        }
        else{
            cityLabel.text = NSLocalizedString("Unknown City", comment: "")
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        self.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerSegue"{
            let destination = segue.destination as! MyTeamsTableViewController
            if !myProfile{
                destination.playerTeams = true
            }
            destination.user = self.user
        } else if segue.identifier == "Chat"{
            var arr = [APIAuth.auth.user!.id, self.user.id]
            arr.sort{Int($0)! < Int($1)!}
            let destination = segue.destination as! ChatVC
            destination.currentUser = self.user
            destination.conversationID = "\(arr[0])_@@_\(arr[1])"
        }
    }
    
    

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return teams.count
        }
        return 5
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        

            return cell
            
        }
        
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
