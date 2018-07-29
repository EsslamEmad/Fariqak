//
//  InvitationTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class InvitationTableViewController: UITableViewController {

    var outgoingInvitations = false
    var incomingInvitations = false
    var invitations = [Invitation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if incomingInvitations{
            fetchIncoming()
        } else if outgoingInvitations{
            fetchOutgoing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchIncoming(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getCommingInvitationsOfUser(userID: APIAuth.auth.user!.id))
            }.done {
                self.invitations = try! JSONDecoder().decode([Invitation].self, from: $0)
                self.tableView.reloadData()
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                
        }
    }
    
    func fetchOutgoing(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getOutcommingInvitationsOfUser(userID: APIAuth.auth.user!.id))
            }.done {
                self.invitations = try! JSONDecoder().decode([Invitation].self, from: $0)
                self.tableView.reloadData()
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                
        }
    }
    
    
    

    // MARK: - Table view data source
    
    var teams: [Team]!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if invitations.count > 0{
            teams = Array(repeating: Team(), count: invitations.count)
        }
        return invitations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvitationTableViewCell
        cell.invitationIDLabel.text = NSLocalizedString("Invitation No.:", comment: "") + " \(invitations[indexPath.row].id)"
        
        cell.hoursLabel.text = NSLocalizedString("From", comment: "") + " \(invitations[indexPath.row].fromTime):00 " + NSLocalizedString("to", comment: "") + " \(invitations[indexPath.row].toTime):00"
        switch invitations[indexPath.row].status{
        case "0":
            cell.statusLabel.text = NSLocalizedString("Waiting", comment: "")
        case "1":
            cell.statusLabel.text = NSLocalizedString("Accepted", comment: "")
        default:
            cell.statusLabel.text = NSLocalizedString("Declined", comment: "")
        }
        firstly{
            return API.CallApi(APIRequests.getTeamByID(id: invitations[indexPath.row].fromTeam))
            }.done {
                let team = try! JSONDecoder().decode(Team.self, from: $0)
                self.teams[indexPath.row] = team
                cell.fromTeamLabel.text!  = NSLocalizedString("From team: ", comment: "") + team.name!
            }.catch{ error in
                
        }
        firstly{
            return API.CallApi(APIRequests.getTeamByID(id: invitations[indexPath.row].toTeam))
            }.done {
                let team = try! JSONDecoder().decode(Team.self, from: $0)
                
                cell.toTeamLabel.text! = NSLocalizedString("To team: ", comment: "") + team.name!
            }.catch { error in
                
        }

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if incomingInvitations, invitations[indexPath.row].status == "0"{
            let alert = UIAlertController(title: "", message: NSLocalizedString("Do you want to accept the invitation?", comment: ""), preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: NSLocalizedString("Accept", comment: ""), style: .default, handler: {_ in
                self.acceptInvitation(id: self.invitations[indexPath.row].id, index: indexPath.row)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Decline", comment: ""), style: .cancel, handler: {_ in
                self.declineInvitation(id: self.invitations[indexPath.row].id, index: indexPath.row)
            })
            alert.addAction(acceptAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
   
    func acceptInvitation(id: String, index: Int){
        SVProgressHUD.show()
        var statusReq = StatusRequest()
        statusReq.status = "1"
        firstly{
            return API.CallApi(APIRequests.acceptInvitation(invitationID: id, statusRequest: statusReq))
            } .done { resp in
                self.showAlert(error: false, withMessage: NSLocalizedString("Accepted", comment: ""), completion: nil)
                var n = UserNotification()
                n.title = "Invitation Accepted تم قبول الدعوة"
                n.userID = self.teams[index].teamLeader!
                firstly{
                    return API.CallApi(APIRequests.sendNotification(notification: n))
                    }.done { resp in } .catch { error in }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func declineInvitation(id: String, index: Int){
        SVProgressHUD.show()
        var statusReq = StatusRequest()
        statusReq.status = "2"
        firstly{
            return API.CallApi(APIRequests.acceptInvitation(invitationID: id, statusRequest: statusReq))
            } .done { resp in
                self.showAlert(error: false, withMessage: NSLocalizedString("Declined", comment: ""), completion: nil)
                var n = UserNotification()
                n.title = "Invitation Declined تم رفض الدعوة "
                n.userID = self.teams[index].teamLeader!
                firstly{
                    return API.CallApi(APIRequests.sendNotification(notification: n))
                    }.done { resp in } .catch { error in }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

}
