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



class MSSignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text{
            
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
            
            if error == nil{
                
                print("User Already Exists")
                if let user = user {
                    print (user)
                  //  self.completeLogin(id: user.uid)
                }
            }
            else{
                
                print("User doesnot exist")
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil
                    {
                        print("Unable to create user")
                    }
                    else
                    {
                        print("Successfully authenticate user")
                        if let user = user {
                            //self.completeLogin(id: user.uid)
                            print(user)
                        }
                    }
                })
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
