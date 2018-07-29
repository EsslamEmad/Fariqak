//
//  LoginViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn
import PromiseKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import SVProgressHUD


class LoginViewController: UIViewController, GIDSignInUIDelegate, FUIAuthDelegate, GIDSignInDelegate {
   
    
    let loginButtoon = FBSDKLoginButton()
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        //GIDSignIn.sharedInstance().uiDelegate = self as! GIDSignInUIDelegate
        //GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Facebook Sign In
    
    
    @IBAction func FacebookSignIn (_ sender: Any?){
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            if let error = error {
                self.showAlert(withMessage: error.localizedDescription)
            } else if result!.isCancelled {
            } else {
                // [START headless_facebook_auth]
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                // [END headless_facebook_auth]
                self.firebaseLogin(credential)
            }
    })
    }
    
    @IBAction func GoogleSignIn(_ sender: Any?){
        
            // [START setup_gid_uidelegate]
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            // [END setup_gid_uidelegate]
        
    }
    
    //Google Sing In
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            self.showAlert(error: true, withMessage: error.localizedDescription, completion: nil)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        firebaseLogin(credential)
    
    }
    
    
        
    func firebaseLogin(_ credential: AuthCredential) {
            
        SVProgressHUD.show()
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        
                            if let error = error {
                                
                                self.showAlert(withMessage: error.localizedDescription)
                                SVProgressHUD.dismiss()
                                return
                            }
                        
                        //self.showAlert(withMessage: "Signed In as\(String(describing: authResult?.user.displayName))")
                        //APIAuth.auth.credential = credential
                        firstly{
                            return API.CallApi(APIRequests.getUser(id: (authResult?.user.uid)!))
                            } .done{ resp in
                                let json = try! JSON(data: resp)
                                if json.array != nil{
                                    self.user.username = (authResult?.user.displayName)!
                                    self.user.firebaseID = (authResult?.user.uid)
                                    self.user.email = (authResult?.user.email) ?? "N/A"
                                    self.user.phone = (authResult?.user.phoneNumber) ?? "000000000"
                                    self.user.cityID = "1"
                                    self.user.photos = authResult?.user.photoURL?.absoluteString ?? ""
                                    firstly{ () -> Promise<Data> in
                                        
                                        return API.CallApi(APIRequests.register(user: self.user))
                                        
                                        } .done{ [weak self] resp -> Void in
                                            
                                            self?.user = try! JSONDecoder().decode(User.self, from: resp)
                                            
                                            print("Success")
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
                            } .finally {
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
