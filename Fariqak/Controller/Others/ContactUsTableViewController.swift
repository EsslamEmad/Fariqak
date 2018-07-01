//
//  ContactUsTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 28/6/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import SkyFloatingLabelTextField

class ContactUsTableViewController: UITableViewController {

    var social: Social!
    var contactUs: ContactUs! = ContactUs()
    
    @IBOutlet weak var username: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var subject: SkyFloatingLabelTextField!
    @IBOutlet weak var message: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getSettings())
            }.done {
                self.social = try! JSONDecoder().decode(Social.self, from: $0)
                
            }.catch { error in
                self.social.facebook = "https://www.facebook.com"
                self.social.twitter = "https://www.twitter.com"
                self.social.youtube = "https://www.youtube.com"
                self.social.instagram = "https://www.instagram.com"
            }.finally {
                SVProgressHUD.dismiss()
        }
        username.text = APIAuth.auth.user?.username
        email.text = APIAuth.auth.user?.email
        phoneNumber.text = APIAuth.auth.user?.phone
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didClickSend(_ sender: Any) {
        guard let name = username.text, let phone = phoneNumber.text, let email = email.text, let subject = subject.text, let message = message.text else{
            self.showAlert(withMessage: "Please, Enter your information!")
            return
        }
        contactUs.name = name
        contactUs.email = email
        contactUs.phone = phone
        contactUs.subject = subject
        contactUs.message = message
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.contactUs(content: contactUs))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Your message has been sent succefully to the administration", completion: nil)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    @IBAction func didClickInstagram(_ sender: Any) {
        UIApplication.shared.open(URL(string: social.instagram)!, options: [:], completionHandler: nil)
    }
    @IBAction func didClickTwitter(_ sender: Any) {
        UIApplication.shared.open(URL(string: social.twitter)!, options: [:], completionHandler: nil)
    }
    @IBAction func didClickYoutube(_ sender: Any) {
        UIApplication.shared.open(URL(string: social.youtube)!, options: [:], completionHandler: nil)
    }
    @IBAction func didClickFacebook(_ sender: Any) {
        UIApplication.shared.open(URL(string: social.facebook)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
