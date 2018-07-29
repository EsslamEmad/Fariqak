//
//  ChatVC.swift
//  Fariqak
//
//  Created by Esslam Emad on 21/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Photos
import Firebase
import PromiseKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    var items = [Message]()
    let barHeight: CGFloat = 50
    var currentUser: User?
    var conversationID: String?
    
    
    //MARK: Methods
    func customization() {
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.title = self.currentUser?.username
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Downloads messages
    func fetchData() {
        print("1.5")
        Database.database().reference().child("chat").child(conversationID!).observe(.childAdded, with: {(snapshot) in
            if snapshot.exists(){
                print("2")
                if let msg = snapshot.value as? NSDictionary{
                    print("3")
                    var message = Message()
                    message.autoID = snapshot.key
                    message.date = msg["date"] as! Int64
                    message.seen = msg["seen"] as! Bool
                    message.text = (msg["text"] as! String)
                    message.type = (msg["type"] as! String)
                    message.user = (msg["user"] as! String)
                    message.userID = (msg["user_id"] as! String)
                    self.items.append(message)
                    self.items.sort{$0.date < $1.date}
                    
                    DispatchQueue.main.async {
                        if !self.items.isEmpty{
                            self.tableView.reloadData()
                            self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                        }
                    }
                }
            }
            
            
        })
        Database.database().reference().child("chat").child(conversationID!).observe(.childChanged, with: {(snapshot) in
            if snapshot.exists(){
                if let index = self.items.index(where: {(item) ->Bool in
                    item.autoID == snapshot.key
                }){
                    let msg  = snapshot.value as! NSDictionary
                    self.items[index].seen = msg["seen"] as! Bool
                    self.tableView.reloadData()
                }
            }
        })
        
        /*Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.id)*/
    }
    
    //Hides current viewcontroller
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func composeMessage(content: Message)  {
        let dict = ["date": content.date, "seen": content.seen, "text": content.text , "type": content.type, "user": content.user, "user_id": content.userID] as [String: Any]
        
        Database.database().reference().child("chat").child(conversationID!).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                Database.database().reference().child("chat").child(self.conversationID!).childByAutoId().setValue(dict)
                var n = UserNotification()
                n.title = "New Message رسالة جديدة"
                n.userID = self.currentUser!.id
                firstly{
                    return API.CallApi(APIRequests.sendNotification(notification: n))
                    }.done { resp in } .catch { error in }
            } else {
                Database.database().reference().child("chat").updateChildValues([self.conversationID!: [String: Any]()], withCompletionBlock: {(Error, Reference) in
                    if let error = Error{
                        self.showAlert(withMessage: error.localizedDescription)
                        return
                    }
                    Reference.child(self.conversationID!).childByAutoId().setValue(dict)
                    var n = UserNotification()
                    n.title = "New Message رسالة جديدة"
                    n.userID = self.currentUser!.id
                    firstly{
                        return API.CallApi(APIRequests.sendNotification(notification: n))
                        }.done { resp in } .catch { error in }
                })
            }
        })
        Database.database().reference().child("contacts").child((APIAuth.auth.user?.id)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
            Database.database().reference().child("contacts").child((APIAuth.auth.user?.id)!).child((self.currentUser?.id)!).observeSingleEvent(of: .value, with: {(snap) in
                if snap.exists(){
                    Database.database().reference().child("contacts").child((APIAuth.auth.user!.id)).child(self.currentUser!.id).setValue(content.date)
                }
                else {
                    Database.database().reference().child("contacts").child(APIAuth.auth.user!.id).updateChildValues([self.currentUser!.id: content.date])
                }
            })
            }
            else {
                Database.database().reference().child("contacts").updateChildValues([APIAuth.auth.user!.id: [String: Any]()], withCompletionBlock: {(error, reference) in
                    reference.child(APIAuth.auth.user!.id).setValue([self.currentUser!.id: content.date])
                })
            }
        })
        Database.database().reference().child("contacts").child(self.currentUser!.id).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                Database.database().reference().child("contacts").child(self.currentUser!.id).child(APIAuth.auth.user!.id).observeSingleEvent(of: .value, with: {(snap) in
                    if snap.exists(){
                        Database.database().reference().child("contacts").child(self.currentUser!.id).child(APIAuth.auth.user!.id).setValue(content.date)
                    }
                    else {
                        Database.database().reference().child("contacts").child(self.currentUser!.id).updateChildValues([APIAuth.auth.user!.id: content.date])
                    }
                })
            }
            else {
                Database.database().reference().child("contacts").updateChildValues([self.currentUser!.id: [String: Any]()], withCompletionBlock: {(error, reference) in
                    reference.child(self.currentUser!.id).setValue([APIAuth.auth.user!.id: content.date])
                })
            }
        })
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.count > 0 {
                var msg = Message()
                msg.text = text
                msg.date = Int64(Date().timeIntervalSince1970 * 1000.0)
                msg.type = "TXT"
                msg.user = Auth.auth().currentUser?.uid ?? ""
                msg.userID = APIAuth.auth.user?.id
                self.composeMessage(content: msg)
                self.inputTextField.text = ""
            }
        }
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            
            if self.items.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = Date(timeIntervalSince1970: Double(items[indexPath.row].date) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 3)
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if Calendar.current.compare(date, to: Date(), toGranularity: .year) == .orderedSame {
            dateFormatter.dateFormat = "MM-dd HH:mm"
            if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
                dateFormatter.dateFormat = "HH:mm"
            }
            
        }
        let strDate = dateFormatter.string(from: date)
        switch self.items[indexPath.row].userID {
        case APIAuth.auth.user?.id:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            cell.message.text = self.items[indexPath.row].text
            if items[indexPath.row].seen{
                cell.seenImage.image = UIImage(named: "double-tick-indicator")
            }
            cell.dateLabel.text = strDate
            return cell
            
        case self.currentUser!.id:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
            
            cell.message.text = self.items[indexPath.row].text
            Database.database().reference().child("chat").child(conversationID!).child(items[indexPath.row].autoID).child("seen").setValue(true)
            cell.dateLabel.text = strDate
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputTextField.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*switch self.items[indexPath.row].userID{
            case APIAuth.auth.user?.id:
            let cell = tableView.cellForRow(at: indexPath) as! ReceiverCell
            return cell.background.frame.height + 10.0
        case self.currentUser!.id:
            let cell = tableView.cellForRow(at: indexPath) as! SenderCell
            return cell.background.frame.height + 10.0
        default:
            return 80.0
        }*/
        
        let constraintRect = CGSize(width: 0.6 * self.view.frame.width, height: .greatestFiniteMagnitude)
        let boundingBox = items[indexPath.row].text!.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont(name: "Arial", size: 17.0)], context: nil)
        
        return ceil(boundingBox.height) + 40.0
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        self.fetchData()
    }
}

