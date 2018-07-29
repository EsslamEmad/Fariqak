//
//  NotificationsTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 28/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class NotificationsTableViewController: UITableViewController {

    var notifications = [UserNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNotifications()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchNotifications(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getNotificationsOfUser(userID: APIAuth.auth.user!.id))
            }.done {
                self.notifications = try! JSONDecoder().decode([UserNotification].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
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
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        
        cell.titleLabel.text = notifications[indexPath.row].title
        
        return cell
    }
 

    

}
