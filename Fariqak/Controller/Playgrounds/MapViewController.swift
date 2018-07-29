//
//  MapViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 11/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    var playground: Playground!
    
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the map view camera
        mapView.camera = GMSCameraPosition.camera(withLatitude: Double(playground.lat ?? "0")!, longitude: Double(playground.lng ?? "0")!, zoom: 6.0)
        //Setting the marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(playground.lat ?? "0")!, longitude: Double(playground.lng ?? "0")!)
        marker.title = playground.title
        marker.snippet = APIAuth.auth.cities.first(where: {$0.code == playground.cityID})?.name ?? ""
        marker.map = mapView
        mapView.isMyLocationEnabled = true
        mapView.accessibilityElementsHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
