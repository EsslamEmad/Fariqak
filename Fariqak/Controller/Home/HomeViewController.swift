//
//  HomeViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 12/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import PromiseKit
import SideMenu

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        if APIAuth.auth.user?.type == "3"{
            searchBar.alpha = 0.0
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let sentence = searchBar.text, sentence != ""{
            performSegue(withIdentifier: "Search Playgrounds", sender: sentence)
        }
    }
    
    @IBAction func sideMenuClicked(_ sender: Any){
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as! UISideMenuNavigationController
        if Language.language == .arabic{
            sideMenu.leftSide = false
        }
        present(sideMenu, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search Playgrounds"{
            let destination = segue.destination as! PlaygroundsTableViewController
            destination.search = true
            destination.searchSentence = sender as! String
        } /*else if segue.identifier == "SideMenu"{
            let destination = segue.destination as! UINavigationController
            //if Language.language == .arabic{ destination.leftSide = false}*/
        
    }
}
