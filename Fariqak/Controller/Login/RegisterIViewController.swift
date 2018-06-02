//
//  RegisterIViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 27/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class RegisterIViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Register(_ sender: Any){
        if email.text != "" , name.text != "", password.text != ""{
            self.performSegue(withIdentifier: "Register", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Register"{
            let controller = segue.destination as! RegisterIITableViewController
            controller.email = email.text
            controller.name = name.text
            controller.password = password.text
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
