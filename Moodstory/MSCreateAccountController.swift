//
//  MSCreateAccountController.swift
//  Moodstory
//
//  Created by Dora Palfi on 2017. 03. 24..
//  Copyright © 2017. MoodStory. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
//import SwiftKeychainWrapper
import FillableLoaders



class MSCreateAccountController: UIViewController {
    
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var maiContainer: UIView!
    
    var loader: FillableLoader = FillableLoader()
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let _: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //           if self.mainContainer.frame.origin.y == 125{
            self.maiContainer.frame.origin.y -= 100
            //          }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.hideKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
        //
        //            performSegue(withIdentifier: "goToCamera", sender: nil)
        //        }
        
        
    }
    
    func path() -> CGPath{
        return Paths.logoPath()
    }
    
    func presentFillableLoader()
    {
        loader.removeLoader(false)
        loader = PlainLoader.showLoader(with: path())
        loader.loaderColor = UIColor.init(colorLiteralRed: 0.0/255.0, green: 152.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        loader.duration = 20
        
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
                if let user = user {
                    
                    self.completeLogin(id: user.uid)
                    
                }
                
            }
        })
    }
    

    
    func completeLogin(id: String) {
        
        loader.removeLoader(true)
        //         let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        //        print("Data saved to Keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToCamera", sender: nil)
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        self.presentFillableLoader()
        
        if let email = emailField.text, let pwd = passwordField.text{
            
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil
                {
                    print("Unable to create user")
                }
                else
                {
                    print("Successfully authenticate user")
                    if let user = user {
                        self.completeLogin(id: user.uid)
                    }
                }
            })
            
            
        }
        
        }
    }

    