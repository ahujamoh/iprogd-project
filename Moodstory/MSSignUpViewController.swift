//
//  MSSignUpViewController.swift
//  Moodstory
//
//  Created by Dora Palfi on 2017. 04. 12..
//  Copyright © 2017. MoodStory. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Malert


class MSSignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var dismissButton = MalertButtonStruct(title: "OK") {
        Malert.shared.dismiss()
    }
    
    // make an alert if the email address already has an associated user
    func userAlreadyExistsAlert() {
        let malertConfiguration = Helper.setUpSecondExampleCustomMalertViewConfig()
        var btConfiguration = MalertButtonConfiguration()
        btConfiguration.tintColor = malertConfiguration.textColor
        btConfiguration.separetorColor = .white
        
        var updatedDismissButton = dismissButton
        updatedDismissButton.setButtonConfiguration(btConfiguration)
        
        Malert.shared.show(viewController: self, title: "Hello!", message: "A user with this email already exists", buttons: [updatedDismissButton], animationType: .modalRight, malertConfiguration: malertConfiguration)
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text{
            User.loginUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil{
                    
                    self.userAlreadyExistsAlert()
                    print("User Already Exists")
                    
                    
                    if let user = user {
                        print (user)
                        //  self.completeLogin(id: user.uid)
                    }
                }
                else{
                    
                    print("User does not exist")
                    //TODO: fix name and profile pic
                    User.registerUser(withName: "test", email: email, password: pwd, profilePic: UIImage(named: "profile pic")! , completion: { (user, error) in
                        if error != nil
                        {
                            print("Unable to create user")
                        }
                        else
                        {
                            print("Successfully authenticate user")
                            if let user = user {
                                //self.completeLogin(id: user.uid)
                                print(user.uid)
                            }
                        }
                    })
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier :"mapView") as! UIViewController
                    self.present(viewController, animated: true)
                    
                    
                }
            })
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
