//
//  HomeButtonsTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 16/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit

class HomeButtonsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0: if APIAuth.auth.user?.type == "1"{
            return 0
            }
        else {
            return 113
            }
        case 1:
            return 350
        case 2:
            return 113
        default: return 0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show My Playgrounds"{
            let destination = segue.destination as! PlaygroundsTableViewController
            destination.owners = true
        } else if segue.identifier == "Show My Playgrounds Reservations"{
            let destination = segue.destination as! ReservationsTableViewController
            destination.owners = true
        }
    }

}
