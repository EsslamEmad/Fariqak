//
//  SearchOpposingTeamViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 25/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class SearchOpposingTeamViewController: UIViewController, UISearchBarDelegate {

    var delegate: SendInvitationControllersDelegate!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil, searchBar.text != ""{
            
            self.dismiss(animated: true, completion: nil)
            delegate.showOpposingTeamsList(search: searchBar.text!)
        }
    }

}
