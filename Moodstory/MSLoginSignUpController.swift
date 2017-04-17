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
import SwiftKeychainWrapper
import FillableLoaders
import Malert

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class MSLoginSignUpController: UIViewController {
    
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var maiContainer: UIView!
    
    var loader: FillableLoader = FillableLoader()
    
    
    var dismissButton = MalertButtonStruct(title: "Cancel") {
        Malert.shared.dismiss()
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let _: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
 //           if self.mainContainer.frame.origin.y == 125{
                //self.maiContainer.frame.origin.y -= 100
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
        
        super.viewDidAppear(animated)
        //loader = PlainLoader.showLoader(with: path())
        
        
        if let _ = KeychainWrapper.standard.string(forKey: GlobalVariables.KEY_UID) {
            
            performSegue(withIdentifier: "goToCamera", sender: nil)
        }

        
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

    
    
    func sentResetEmailAlert() {
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
    
    Malert.shared.show(viewController: self, title: "Reset password", message: "New Password has been sent", buttons: [showThirdExempleButton, updatedDismissButton], animationType: .modalRight, malertConfiguration: malertConfiguration)
    }
    
    
    func showResetPwdAlert() {
        let malertConfig = Helper.setUpSecondExampleCustomMalertViewConfig()
        var btConfiguration = MalertButtonConfiguration()
        btConfiguration.tintColor = malertConfig.textColor
        btConfiguration.separetorColor = .clear
        
        var updatedDismissButton = dismissButton
        updatedDismissButton.setButtonConfiguration(btConfiguration)
        
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Your email"
        
        let thatIsAllFolksButton = MalertButtonStruct(title: "Send", buttonConfiguration: btConfiguration) {
            
            if let resetEmail = textField.text?.lowercased() {
                
                
                FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmail) { (error) in
                    if error != nil {
                        
                        let myColor : UIColor = UIColor( red: 1.0, green: 0, blue:0, alpha: 1.0 )
                        textField.layer.borderColor = myColor.cgColor
                        textField.layer.borderWidth = 0.5
                        
                    } else {
                        
                        self.sentResetEmailAlert()
                        Malert.shared.dismiss(with: {[weak self] (_) in
                            guard let strongSelf = self else { return }
                        })
                        
                    }
                    
                }
            }
            
        }
        
        Malert.shared.show(viewController: self, title: "Reset password", customView: textField, buttons: [thatIsAllFolksButton, updatedDismissButton], animationType: .modalLeft, malertConfiguration: malertConfig, tapToDismiss: false)
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
    
    @IBAction func forgotBtnPressed(_ sender: Any) {
        
        if let resetEmail = emailField.text {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmail) { (error) in
                if error != nil {
                    
                    self.showResetPwdAlert()
                    
                } else {
            
                    self.sentResetEmailAlert()
            
                }
                
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

    @IBAction func loginTapped(_ sender: Any) {
        
        self.presentFillableLoader()
        
        if let email = emailField.text, let pwd = passwordField.text{
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil{
                    
                    print("Email User Authenticated with Firebase")
                    if let user = user {
                    self.completeLogin(id: user.uid)
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
                                self.completeLogin(id: user.uid)
                            }
                        }
                    })
                }
            })
        
        }
        
    }
    
    func completeLogin(id: String) {
        
        loader.removeLoader(true)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: GlobalVariables.KEY_UID)
        print("Data saved to Keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToCamera", sender: nil)
        
    }
    
    
   
    
}

