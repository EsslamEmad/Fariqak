//
//  NewTeamViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 20/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD

class NewTeamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    
    var team = Team()
    var players = [User]()
    var teamPlayers = Array(repeating: "", count: 11)
    var i: Int!
    
    //Mark: Outlets
    
    @IBOutlet var teamLogo: UIImageView!
    @IBOutlet weak var teamName: SkyFloatingLabelTextField!
    @IBOutlet weak var playgroundImage: UIImageView!
    @IBOutlet weak var viewXPosition: NSLayoutConstraint!
    @IBOutlet weak var tableXPosition: NSLayoutConstraint!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Mark: 11 Buttons and Labels Outlets
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var label11: UILabel!
    
    var buttonsArray = [UIButton]()
    var labelsArray = [UILabel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playgroundImage.transform = playgroundImage.transform.rotated(by: CGFloat(M_PI_2))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.sectionHeaderHeight = 60
        buttonsArray = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11]
        labelsArray = [label1, label2, label3, label4, label5, label6, label7, label8, label9, label10, label11]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func didClickSave(_ sender: Any) {
        
        guard let name = teamName.text, name != "" else{
            self.showAlert(withMessage: "Please enter the team name!")
            return
        }
        SVProgressHUD.show()
        if ImagePicked{
            firstly{
                return API.CallApi(APIRequests.upload(photo: self.teamLogo.image!))
                } .done{
                    let response = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                    self.team.logo = response.image
                    print("uploaded succefully")
                    self.addTeamRequest()
                }.catch{_ in
                    self.showAlert(withMessage: "Couldn't upload the photo")
                    SVProgressHUD.dismiss()
            }
        } else {
            self.addTeamRequest()
        }
        
    }
    func addTeamRequest(){
        team.players = teamPlayers
        team.name = teamName.text
        team.teamLeader = APIAuth.auth.user?.id
        firstly{
            return API.CallApi(APIRequests.addTeam(team: team))
            } .done{ resp in
                self.showAlert(error: false, withMessage: "Your team is saved succefully", completion: nil)
                
            } .catch{
                self.showAlert(error: true, withMessage: $0.localizedDescription, completion: nil)
            } .finally{
                SVProgressHUD.dismiss()
        }
    }
    
    
    //Mark: Search Popup
    
    @IBAction func addMember(_ sender: UIButton) {
        i = sender.tag
        viewXPosition.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
            })
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        viewXPosition.constant = -1000
        tableXPosition.constant = 1000
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
        
    }
    
    @IBAction func didClickSearch(_ sender: Any) {
        var req = SearchRequest()
        req.text = searchBar.text!
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.searchUsers(searchRequest: req))
            } .done{
                self.players = try! JSONDecoder().decode([User].self, from: $0)
                self.viewXPosition.constant = -1000
                self.tableXPosition.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()})
                
            } .catch{
                self.showAlert(withMessage: $0.localizedDescription)
            } .finally{
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    
    //Mark: Players Table Popup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChoosePlayerTableViewCell
        cell.name.text = players[indexPath.row].username
        if let imgurl = URL(string: players[indexPath.row].photos), players[indexPath.row].photos != ""{
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: imgurl, options: [.transition(.fade(0.2))])
        }
        else{
            cell.img.image = UIImage(named: "man")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChoosePlayerTableViewCell
        
        labelsArray[i].text = cell.name.text
        do{
            if let imgurl = URL(string: players[indexPath.row].photos){
                try Data(contentsOf: imgurl)}
            buttonsArray[i].setImage(cell.img.image, for: .normal)
        } catch{
            buttonsArray[i].setImage(UIImage(named: "man"), for: .normal)
        }
        teamPlayers[i] = players[indexPath.row].id
        dismissPopup(backgroundButton)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        
        return headerCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Mark: Picking Team Logo
    
     @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
     if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
     let picker = UIImagePickerController()
     picker.delegate = self
     picker.allowsEditing = false
     picker.sourceType = .photoLibrary
     present(picker, animated: true, completion: nil)
     }
     else{
     self.showAlert(withMessage: "Application can not access photo library.")
     }
     }
    
    var ImagePicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            teamLogo.image = selectedImage
            teamLogo.contentMode = .scaleAspectFit
            teamLogo.clipsToBounds = true
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
