//
//  TeamViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class TeamViewController: UIViewController {

    var team: Team!
    var i: Int!
    
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playgroundImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    
    //Mark: Buttons and Labels Outlets
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
    
    var buttonsArray: [UIButton]!
    var labelsArray: [UILabel]!
    var players = Array(repeating: User(), count: 11)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playgroundImage.transform = playgroundImage.transform.rotated(by: CGFloat(M_PI_2))
        buttonsArray = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11]
        labelsArray = [label1, label2, label3, label4, label5, label6, label7, label8, label9, label10, label11]
        teamNameLabel.text = team.name
        if let logo = team.logo, logo != ""{
            if let imgurl = URL(string: logo){
                teamLogo.kf.indicatorType = .activity
                teamLogo.kf.setImage(with: imgurl)
                
            }
        }
        teamLogo.layer.cornerRadius = 32.0
        teamLogo.clipsToBounds = true
        self.title = team.name
        if APIAuth.auth.user?.id != team.teamLeader {
            editButton.setImage(nil, for: .normal)
            editButton.isEnabled = false
        }
        fetchPlayers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPlayers(){
        i = 0
        for j in 0...team.players.count - 1{
            if j == 11{
                SVProgressHUD.dismiss()
                return
            }
            SVProgressHUD.show()
            let k = j
            firstly{
                return API.CallApi(APIRequests.getUserByID(id: team.players[k]))
                }.done{
                    let currentplayer = try!JSONDecoder().decode(User.self, from: $0)
                    do{
                        if let imgurl = URL(string: currentplayer.photos){
                            let data = try Data(contentsOf: imgurl)
                            self.buttonsArray[k].setImage(UIImage(data: data), for: .normal)
                        } else {
                            self.buttonsArray[k].setImage(UIImage(named: "man"), for: .normal)
                        }
                    } catch {
                        self.buttonsArray[k].setImage(UIImage(named: "man"), for: .normal)
                    }
                    self.labelsArray[k].text = currentplayer.username
                    self.players[k] = currentplayer
                    self.i = self.i + 1
                    if self.i == self.team.players.count{
                        SVProgressHUD.dismiss()
                    }
                } .catch{ error in
                    self.i = self.i + 1
                    if self.i == self.team.players.count{
                        SVProgressHUD.dismiss()
            }
           
        }
    }
    }
    
    
    
    
    @IBAction func showPlayer(_ sender: UIButton) {
        let tag = sender.tag
        guard players[tag].id != "" else {
            return
        }
        performSegue(withIdentifier: "ProfileSegue", sender: players[tag])
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue"{
            let destination = segue.destination as! MyProfileTableViewController
            destination.user = sender as! User
            destination.myProfile = false
        }
        if segue.identifier == "EditSegue"{
            let destination = segue.destination as! EditTeamViewController
            destination.team = team
        }
    }
    
    

}
