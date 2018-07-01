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
import SwiftyJSON
import SVProgressHUD

class EmailLoginViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //subscribeToKeyboardNotifications()
        view.endEditing(false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(_ sender: Any){
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: email.text!, password: password.text!){(user, error) in
            
            if let error = error {
                
                self.showAlert(withMessage: error.localizedDescription)
                return
            }
            
           // self.showAlert(withMessage: "Signed In as \(user?.uid, user?.email)")
            firstly{
                return API.CallApi(APIRequests.getUser(id: (user?.uid)!))
                } .done{ resp in
                    let json = try! JSON(data: resp)
                    if json.array != nil{
                        self.user.username = (user?.displayName) ?? "Unknown"
                        self.user.firebaseID = (user?.uid)
                        self.user.email = (user?.email)!
                        self.user.phone = (user?.phoneNumber) ?? "000000000"
                        self.user.cityID = "1"
                        firstly{ () -> Promise<Data> in
                            
                            return API.CallApi(APIRequests.register(user: self.user))
                            
                            } .done{ [weak self] resp -> Void in
                                
                                self?.user = try! JSONDecoder().decode(User.self, from: resp)
                                
                                self?.performMainSegue()
                                
                            } .catch{ [weak self] error in
                                
                                self?.showAlert(withMessage: error.localizedDescription)
                        }
                    }
                    else if json.dictionary != nil{
                        self.user = try! JSONDecoder().decode(User.self, from: resp)
                        self.performMainSegue()}
                } .catch{
                    print($0.localizedDescription)
                }.finally {
                    SVProgressHUD.dismiss()
            }
        }
        
    }

    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        APIAuth.auth.user = self.user
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
