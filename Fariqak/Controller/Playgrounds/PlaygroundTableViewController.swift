//
//  PlaygroundTableViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import ImageSlideshow
import Cosmos
import GoogleMaps

class PlaygroundTableViewController: UITableViewController {

    var playground: Playground!
    var inputs = [InputSource]()
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = playground.title
        fetchPhotos()
        
        //Configuring the view
        priceLabel.text = "\(playground.price) " + NSLocalizedString("S.R", comment: "")
        nameLabel.text = playground.title
        descriptionLabel.text = NSLocalizedString("Details:", comment: "") + "\n\(playground.details)"
        
        //Setting the rating view Stars
        ratingView.rating = Double(playground.rate ?? "0.0")!
        ratingView.settings.fillMode = .precise
        
        //Setting the Image Slide Show Object
        slideShow.setImageInputs(inputs)
        slideShow.slideshowInterval = 2.0
        slideShow.contentScaleMode = .scaleAspectFill
        slideShow.clipsToBounds = true
        
        
        //Setting the map view camera
        mapView.camera = GMSCameraPosition.camera(withLatitude: Double(playground.lat ?? "0")!, longitude: Double(playground.lng ?? "0")!, zoom: 12.0)
        //Setting the marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(playground.lat ?? "0")!, longitude: Double(playground.lng ?? "0")!)
        marker.title = playground.title
        marker.snippet = APIAuth.auth.cities.first(where: {$0.code == playground.cityID})?.name ?? ""
        marker.map = mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressReserve(_ sender: Any) {
    }
    
    func fetchPhotos(){
        let photo = playground.photo
        playground.photos?.append(photo)
        for photo in playground.photos!{
            if let imgurl = URL(string: photo){
                inputs.append(KingfisherSource(url: imgurl))
            }
        }
        
    }
    //MArk:- Setting map and reservation navigation
    @objc func didTapOnMapView() {
        performSegue(withIdentifier: "Show Map", sender: playground)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Map" {
            let destination = segue.destination as! MapViewController
            destination.playground = playground
        }
        if segue.identifier == "Reserve"{
            let destination = segue.destination as! ReservingPlaygroundTableViewController
            destination.playgroundID = playground.code
            destination.price = Int(playground.price)
            destination.ownerID = playground.owner
        }
    }
    @IBAction func unwindToPlayground(_ sender: UIStoryboardSegue) {
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            didTapOnMapView()
        }
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
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
