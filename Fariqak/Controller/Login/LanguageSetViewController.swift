//
//  LanguageSetViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 16/5/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import Foundation

class LanguageSetViewController: UIViewController {

    var user1 = [City]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the URL the request is being made to.
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func arSet(_ sender: Any?){
        Language.language = Language.arabic
        performMainSegue()
        
    }
    @IBAction func enSet(_ sender: Any?){
        Language.language = Language.english
        performMainSegue()
    }
    
    func performMainSegue (animated: Bool = true)
    {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
