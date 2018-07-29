//
//  SideMenuTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SideMenuManager.default.menuLeftNavigationController?.sideMenuDelegate = self

        
        if let image = APIAuth.auth.user?.photos, image != ""{
            if let imgurl = URL(string: image){
                profilePicture.kf.indicatorType = .activity
                profilePicture.kf.setImage(with: imgurl)
                profilePicture.layer.cornerRadius = 32.0
                profilePicture.clipsToBounds = true
            }
        }
        nameLabel.text = APIAuth.auth.user?.username
        emailLabel.text = APIAuth.auth.user?.email ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressSignOut(_ sender: Any?){
        let alert = UIAlertController(title: NSLocalizedString("Sign Out", comment: ""), message: NSLocalizedString("Are you sure you want to sign out?", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in self.signOut()})
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            APIAuth.auth.logout()
            performMainSegue()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }

    
    @IBAction func didPressIncomingInvitations(_ sender: UIButton!){
        performSegue(withIdentifier: "ShowInvitations", sender: true)
    }
    @IBAction func didPressOutgoingInvitations(_ sender: UIButton!){
        performSegue(withIdentifier: "ShowInvitations", sender: false)
    }
    
    @IBAction func didPressLanguage(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Language", comment: ""), message: NSLocalizedString("Choose the language!", comment: ""), preferredStyle: .actionSheet)
        let eng = UIAlertAction(title: "English", style: .default, handler: {(UIAlertAction) -> Void in
            guard Language.language != .english else{
                return
            }
            Language.language = .english
            self.showAlert(error: false, withMessage: "Please, restart the application to change the language!", completion: nil)
        })
        let ar = UIAlertAction(title: "عربي", style: .default, handler: {(UIAlertAction) -> Void in
            guard Language.language != .arabic else {
                return
            }
            Language.language = .arabic
            self.showAlert(error: false, withMessage: "من فضلك، أعد تشغيل التطبيق لتغيير اللغة", completion: nil)
        })
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(eng)
        alert.addAction(ar)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllTeamsSegue"{
            let destination = segue.destination as! MyTeamsTableViewController
            destination.allTeams = true
        } else if segue.identifier == "Show My Playgrounds"{
            let destination = segue.destination as! PlaygroundsTableViewController
            destination.owners = true
        } else if segue.identifier == "ShowInvitations"{
            let destination = segue.destination as! InvitationTableViewController
            if sender as! Bool{
                destination.incomingInvitations = true
            } else {
                destination.outgoingInvitations = true
            }
        }
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 || indexPath.row == 3{
            if APIAuth.auth.user?.type == "1"{
                return 0
            }
            else {
                return 80
            }
        }
        return 80
    }

    
 

}
