//
//  ViewController.swift
//  Moodstory
//
//  Created by Muhammad Mustafa Saeed on 3/14/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class MSLoginSignUpController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        // Authenticate with Facebook
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil{
                print("Unable to authenticate with Facebook")
            }
            else if result?.isCancelled == true {
                
                print("User Cancelled facebook Authentication")
            }
            else
            {
                print("Successfully Authenticated with Facebook")
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credentials)
            }
            
        }
        
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil
            {
                print("Unable to authenticate with Firebase - \(String(describing: error))")
            }
            else
            {
                print("Successfully Authenticated with Firebase")
            }
        })
    }

}

