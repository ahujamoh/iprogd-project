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

class MSMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let manager = CLLocationManager()

    func locationManager(_ _manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    }
    
  
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        //set location to Stockholm
        self.initialLocation()
        
        //get user location
        //self.getUserLocation()
        
        showAnnotation()
        
    }
    
    
    func showAnnotation() {
        print("sara: show Annotation")
        let annotation = MKPointAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(59.334415, 18.110103)
        annotation.coordinate = location
        annotation.title = "Hej"
        mapView.addAnnotation(annotation)
        print("visar annotation")
        
    }
    
    func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("sara:  mapView 1")
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        print("sara: mapView 2")
        let reuseId = "CustomMarker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as MKAnnotationView?
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.image = UIImage(named: "anno")
        }
        else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    //sets initial location to Stockholm
    func initialLocation() {
        
        let location = CLLocationCoordinate2DMake(59.334591, 18.063240)
        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: true)
    
    }
    
    
    //user location
    
    func getUserLocation() {
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
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
