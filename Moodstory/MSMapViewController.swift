//
//  MSMapViewController.swift
//  Moodstory
//
//  Created by Sara Eriksson on 2017-04-16.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MSMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let manager = CLLocationManager()
    func locationManager(_manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.15, 0.15)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //self.initialLocation()
        

    }
    
    //sets initial location to Stockholm
    func initialLocation() {
        
        let location = CLLocationCoordinate2DMake(59.334591, 18.063240)
        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: true)
    
    }
    
    //markers

    
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
