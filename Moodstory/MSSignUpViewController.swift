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
    
    var dismissButton = MalertButtonStruct(title: "Cancel") {
        Malert.shared.dismiss()
    }
    
    func userAlreadyExistsAlert() {
        let malertConfiguration = Helper.setUpSecondExampleCustomMalertViewConfig()
        var btConfiguration = MalertButtonConfiguration()
        btConfiguration.tintColor = malertConfiguration.textColor
        btConfiguration.separetorColor = .white
        
        let showThirdExempleButton = MalertButtonStruct(title: "OK", buttonConfiguration: btConfiguration) { [weak self] in
            guard let strongSelf = self else { return }
            Malert.shared.dismiss(with: { (finished) in
            })
        }
        
        var updatedDismissButton = dismissButton
        updatedDismissButton.setButtonConfiguration(btConfiguration)
        
        Malert.shared.show(viewController: self, title: "Hello!", message: "New Password has been sent", buttons: [showThirdExempleButton, updatedDismissButton], animationType: .modalRight, malertConfiguration: malertConfiguration)
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text{
            
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
            
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
