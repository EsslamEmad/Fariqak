//
//  ChooseOpposingTeamTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class ChooseOpposingTeamTableViewController: UITableViewController {

    var teams = [Team]()
    var searchSentence: String!
    var delegate: SendInvitationControllersDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOpposingTeams()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchOpposingTeams(){
        var searchReq = SearchRequest()
        searchReq.text = searchSentence
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.searchTeams(searchRequest: searchReq))
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChooseOpposingTeamTableViewCell
        if teams[indexPath.row].logo != "", let imgurl = URL(string: teams[indexPath.row].logo!){
            cell.teamLogo.kf.indicatorType = .activity
            cell.teamLogo.kf.setImage(with: imgurl)
        }
        cell.teamName.text = teams[indexPath.row].name
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate.sendInvitation(teamID: teams[indexPath.row].teamID!, teamLeaderID: teams[indexPath.row].teamLeader!)
    }
 

    

}
