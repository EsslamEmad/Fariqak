//
//  AddLocationMapViewController.swift
//  Fariqak
//
//  Created by Esslam Emad on 16/7/18.
//  Copyright © 2018 Esslam Emad. All rights reserved.
//

import UIKit
import GoogleMaps

class AddLocationMapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.isMyLocationEnabled = true
        if let myLocation = mapView.myLocation{
            mapView.camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 12.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            marker.map = mapView
        } else {
            mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 2.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            marker.map = mapView
            
        }
        mapView.accessibilityElementsHidden = false
        mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.clear()
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
    @IBAction func didPressDone(_ sender: UIButton) {
        performSegue(withIdentifier: "Back From Map View", sender: mapView.selectedMarker)
    }
    
}
