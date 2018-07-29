//
//  ReservationsTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 15/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class ReservationsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, SendInvitationControllersDelegate {

    
    var reservations = [Reservation]()
    var owners = false
    var users: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if owners{
            fetchMyPlaygroundsReservations()
        } else {
            fetchReservations()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchReservations(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getReservationsOfUser(userID: (APIAuth.auth.user?.id)!))
            }.done {
                self.reservations = try! JSONDecoder().decode([Reservation].self, from: $0)
                self.tableView.reloadData()
            }.catch{ error in
                self.showAlert(withMessage: error.localizedDescription)
            }.finally{
                SVProgressHUD.dismiss()
        }
    }
    
    func fetchMyPlaygroundsReservations(){
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getReservationsOfOwner(ownerID: (APIAuth.auth.user?.id)!))
            }.done {
                self.reservations = try! JSONDecoder().decode([Reservation].self, from: $0)
                self.tableView.reloadData()
                self.fetchReservationUsers()
            }.catch{ error in
                self.showAlert(withMessage: error.localizedDescription)
            }.finally{
                SVProgressHUD.dismiss()
        }
    }
    
    func fetchReservationUsers(){
        users = Array(repeating: User(), count: reservations.count)
        var completed = 0
        SVProgressHUD.show()
        for i in 0 ... reservations.count - 1{
            firstly{
                return API.CallApi(APIRequests.getUserByID(id: reservations[i].teamLeaderID))
                }.done {
                    self.users[i] = try! JSONDecoder().decode(User.self, from: $0)
                    
                }.catch{ error in
                }.finally {
                    completed += 1
                    if completed == self.reservations.count{
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ReservationTableViewCell
        let reservation = reservations[indexPath.row]
        cell.reservationImageView.clipsToBounds = true
        cell.reservationImageView.layer.cornerRadius = 32.0
        cell.idLabel.text = NSLocalizedString("Reservation ID: ", comment: "") + reservation.id
        cell.dateLabel.text = NSLocalizedString("Date: " , comment: "") + reservation.date
        cell.fromLabel.text = NSLocalizedString("Starting at: ", comment: "") + reservation.fromHour
        cell.toLabel.text = NSLocalizedString("Ending at: ", comment: "") + reservation.toHour
        var state: String!
        switch reservation.status{
        case "0":
            state = NSLocalizedString("Waiting", comment: "")
        case "1":
            state = NSLocalizedString("Accepted", comment: "")
        default:
            state = NSLocalizedString("Declined", comment: "")
        }
        cell.statusLabel.text = NSLocalizedString("Status: ", comment: "") + state
        if owners, users[indexPath.row].username != ""{
            cell.reserverButton.setTitle(NSLocalizedString("Reservation from: ", comment: "") + users[indexPath.row].username, for: .normal)
            cell.reserverButton.alpha = 1
            cell.reserverButton.tag = indexPath.row
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if owners, reservations[indexPath.row].status == "0"{
            ownerRespondOfReservation(reservation: reservations[indexPath.row])
        } else if !owners, reservations[indexPath.row].status == "1"{
            selectedReservation = reservations[indexPath.row]
            userActionForAcceptedReservation()
        }
    }
    
    
    
    //Mark: Owner acception for Reservation
    
    func ownerRespondOfReservation(reservation: Reservation){
        let alert = UIAlertController(title: "", message: NSLocalizedString("Do you want to accept the reservation?", comment: ""), preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: NSLocalizedString("Accept", comment: ""), style: .default, handler: {_ in
            self.acceptReservation(reservation: reservation)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func acceptReservation(reservation: Reservation){
        SVProgressHUD.show()
        var statusReq = StatusRequest()
        statusReq.status = "1"
        firstly{
            return API.CallApi(APIRequests.acceptReservation(reservationID: reservation.id, statusRequest: statusReq))
            }.done { resp in
                self.showAlert(error: false, withMessage: NSLocalizedString("You accepted the reservation", comment: ""), completion: nil)
                var n = UserNotification()
                n.title = "Reservation Feedback تم الرد على الحجز"
                n.userID = reservation.teamLeaderID
                firstly{
                    return API.CallApi(APIRequests.sendNotification(notification: n))
                    }.done { resp in } .catch { error in }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                
            }.finally {
                SVProgressHUD.dismiss()
                self.viewDidLoad()
        }
    }
    
    @IBAction func didPressOnUser(_ sender: UIButton){
        performSegue(withIdentifier: "Show Player", sender: users[sender.tag])
    }
    
    
    //Mark: User actions for inviting a team
    
    var selectedReservation: Reservation!
    var myTeam: String!
    
    func userActionForAcceptedReservation(){
        let alert = UIAlertController(title: NSLocalizedString("Invite", comment: ""), message: NSLocalizedString("Do you want to Invite a team?", comment: ""), preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: NSLocalizedString("Invite", comment: ""), style: .default, handler: {_ in
            self.showTeamsList()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func showTeamsList(){
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseYourTeam") as! ChooseYourTeamViewController
        popController.delegate = self
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: tableView.indexPathForSelectedRow!)
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        
        
        popController.popoverPresentationController?.delegate = self
        
        self.present(popController, animated: true, completion: nil)
        
    }
    
    func showSearchController(teamID: String){
        
        myTeam = teamID
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchOpposingTeam") as! SearchOpposingTeamViewController
        popController.delegate = self
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: tableView.indexPathForSelectedRow!)
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        
        
        popController.popoverPresentationController?.delegate = self
        
        self.present(popController, animated: true, completion: nil)
    }
    
    func showOpposingTeamsList(search: String){
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseOpposingTeam") as! ChooseOpposingTeamTableViewController
        popController.delegate = self
        popController.searchSentence = search
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: tableView.indexPathForSelectedRow!)
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        
        
        popController.popoverPresentationController?.delegate = self
        
        self.present(popController, animated: true, completion: nil)
    }
    
    func sendInvitation(teamID: String, teamLeaderID: String){
        var invitation = Invitation()
        invitation.fromTeam = myTeam
        invitation.toTeam = teamID
        invitation.reservationID = selectedReservation.id
        invitation.playgroundID = selectedReservation.playgroundID
        invitation.fromTime = selectedReservation.fromHour
        invitation.toTime = selectedReservation.toHour
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.addInvitation(invitation: invitation))
            }.done { resp in
                self.showAlert(error: false, withMessage: NSLocalizedString("Your Invitation was succefully sent!", comment: ""), completion: nil)
                var n = UserNotification()
                n.title = "New Invitation دعوة جديدة"
                n.userID = teamLeaderID
                firstly{
                    return API.CallApi(APIRequests.sendNotification(notification: n))
                    }.done { resp in } .catch { error in }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.containerView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Player"{
            let destination = segue.destination as! MyProfileTableViewController
            destination.myProfile = false
            destination.user = sender as! User
        }
    }
    
    

}

protocol SendInvitationControllersDelegate{
    func showSearchController(teamID: String)
    func showOpposingTeamsList(search: String)
    func sendInvitation(teamID: String, teamLeaderID: String)
}

