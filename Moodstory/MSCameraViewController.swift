//
//  CameraViewController.swift
//  Moodstory
//
//  Created by Muhammad Mustafa Saeed on 3/14/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import SwiftKeychainWrapper
import GoogleMaps
import GooglePlaces


class MSCameraViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 6.0
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        displayMarkers()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 30)!,NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "mood story"
    }
    
    func displayMarkers() {
        //(59.369396, 18.004532): Solna
        let position = CLLocationCoordinate2D(latitude: 59.369396, longitude: 18.004532)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = mapView
        
        let position1 = CLLocationCoordinate2D(latitude: 59.369396, longitude: 19.004532)
        let marker1 = GMSMarker(position: position1)
        marker1.title = "Hello World1"
        marker1.map = mapView
        marker1.icon = GMSMarker.markerImage(with: .black)
        
        let position2 = CLLocationCoordinate2D(latitude: 60.369396, longitude: 19.004532)
        let marker2 = GMSMarker(position: position2)
        marker2.title = "Hello World2"
        marker2.map = mapView
        marker2.icon = GMSMarker.markerImage(with: .green)
        
        let position3 = CLLocationCoordinate2D(latitude: 60.369396, longitude: 18.004532)
        let marker3 = GMSMarker(position: position3)
        marker3.title = "Hello World2"
        marker3.map = mapView
        marker3.icon = GMSMarker.markerImage(with: .clear)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        
        // TODO: Signout from Firebase and remove string from keychain
        
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: GlobalVariables.KEY_UID)
        print("ID removed from keyhain : \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLoginScreen", sender: nil)
    }
    
    
}

// PRAGMA - google classes

extension MSCameraViewController: CLLocationManagerDelegate{
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        displayMarkers()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
