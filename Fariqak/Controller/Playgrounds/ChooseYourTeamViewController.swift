//
//  ChooseYourTeamViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class ChooseYourTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTeams = [Team]()
    @IBOutlet weak var tableView: UITableView!
    var delegate: SendInvitationControllersDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchMyTeams()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMyTeams(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUserTeams(userID: (APIAuth.auth.user?.id)!))
            } .done {
                self.myTeams = try! JSONDecoder().decode([Team].self, from: $0)
                self.tableView.reloadData()
            } .catch { error in
                print(error.localizedDescription)
            } .finally {
                SVProgressHUD.dismiss()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChooseYourTeamTableViewCell
        
        if let imgurl = URL(string: myTeams[indexPath.row].logo!){
            cell.teamLogo.kf.indicatorType = .activity
            cell.teamLogo.kf.setImage(with: imgurl)
        }
        cell.teamName.text = myTeams[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate.showSearchController(teamID: myTeams[indexPath.row].teamID!)
        
    }
    
    

}
