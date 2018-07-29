//
//  ConversationsVC.swift
//  Fariqak
//
//  Created by Esslam Emad on 21/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import PromiseKit

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var items = [Chat]()
    var selectedUser: User?
    
    //MARK: Methods
    /*func customization()  {
        // notification setup
       /* NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showEmailAlert), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)*/
        
        
        //left bar button image fetching
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                let image = user.profilePic
                let contentSize = CGSize.init(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
                path.lineWidth = 2
                UIColor.white.setStroke()
                path.stroke()
                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    weakSelf?.leftButton.image = finalImage
                    weakSelf = nil
                }
            })
        }
    }*/
    
    //Downloads conversations
    func fetchData() {
        
        /*let ref = Database.database().reference().child("chat").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                
                let keys = snapshot.value as! NSDictionary
                for key in keys.allKeys{
                    
                    let keyString = key as! String
                    let arrayKeyString = keyString.components(separatedBy: "_@@_")
                    print(keyString)
                    if arrayKeyString.contains((APIAuth.auth.user?.id)!){
                        var chat = Chat()
                        chat.id = keyString
                        print(chat.id)
                        chat.userId = arrayKeyString
                        chat.anotherID = arrayKeyString[0] == (APIAuth.auth.user?.id)! ? arrayKeyString[1] : arrayKeyString[0]
                        print(chat.anotherID)
                        print(arrayKeyString[0])
                        print(arrayKeyString[1])
                        self.items.append(chat)
                        
                        
                    }
                }
            }
        })*/
        Database.database().reference().child("contacts").child(APIAuth.auth.user!.id).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists(){
                let key = snapshot.key
                var chat = Chat()
                chat.lastMsgTime = snapshot.value as! Int64
                chat.id = key
                chat.userId = [key, APIAuth.auth.user?.id] as! [String]
                self.items.append(chat)
                self.items.sort{$0.lastMsgTime > $1.lastMsgTime}
                self.tableView.reloadData()
                
                
            }
        })
    }
    
    
    
    
    
    
    
    //Shows Chat viewcontroller with given user
    @objc func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Chat" {
            var arr = [APIAuth.auth.user!.id, self.selectedUser!.id]
            arr.sort{Int($0)! < Int($1)!}
        let destination = segue.destination as! ChatVC
        destination.currentUser = self.selectedUser
        destination.conversationID = "\(arr[0])_@@_\(arr[1])"
        }
    }
    
    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTBCell
            //cell.clearCellData()
            SVProgressHUD.show()
            firstly{
                return API.CallApi(APIRequests.getUserByID(id: items[indexPath.row].id))
                }.done {
                    let user = try! JSONDecoder().decode(User.self, from: $0)
                    self.items[indexPath.row].user = user
                    if let imgurl = URL(string: user.photos){
                        cell.profilePic.kf.indicatorType = .activity
                        cell.profilePic.kf.setImage(with: imgurl)
                    }
                    cell.nameLabel.text = user.username
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                }.finally {
                    SVProgressHUD.dismiss()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "Chat", sender: self)
        }
    }
    
    //MARK: ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.customization()
        tableView.delegate = self
        tableView.dataSource = self
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}
