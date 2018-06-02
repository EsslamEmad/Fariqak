//
//  EmailLoginViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 27/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

class EmailLoginViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        view.endEditing(false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(_ sender: Any){
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!){(user, error) in
            
            if let error = error {
                
                self.showAlert(withMessage: error.localizedDescription)
                return
            }
            
            self.showAlert(withMessage: "Signed In as \(user?.uid, user?.email)")
            firstly{
                return API.CallApi(APIRequests.getUser(id: (user?.uid)!))
                } .done{
                    self.user = try! JSONDecoder().decode(User.self, from: $0)
                    self.performMainSegue()
                } .catch{
                    print($0.localizedDescription)
            }
        }
        
    }

    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
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
