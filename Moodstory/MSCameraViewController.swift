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


class MSCameraViewController: UIViewController {
   
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    override func loadView() {
        //currently setting just the location to singaport
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        //putting the view on the place on the map
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutBtnTapped(_ sender: Any) {
        
       // TODO: Signout from Firebase and remove string from keychain
        
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ID removed from keyhain : \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLoginScreen", sender: nil)
    }
    

}
