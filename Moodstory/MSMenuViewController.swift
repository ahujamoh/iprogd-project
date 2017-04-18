//
//  MSMenuViewController.swift
//  Moodstory
//
//  Created by Muhammad Mustafa Saeed on 3/18/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MSMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var nameOfUser: UILabel!
    
    @IBAction func showProfilePicButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"profilePicView") as! UIViewController
        self.present(viewController, animated: true)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        ProfilePicture.layer.borderWidth = 1
        ProfilePicture.layer.masksToBounds = false
        ProfilePicture.layer.borderColor = UIColor.white.cgColor
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.height/2
        ProfilePicture.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Table view data source
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return 3
            return 4
    }
//cells in the menu corresponding to different parts of our app
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        if indexPath.row == 0{
            cell?.textLabel?.text = "Map"
        }
        else if indexPath.row == 1{
            cell?.textLabel?.text = "Message"
        }
        else if indexPath.row == 2{
            cell?.textLabel?.text = "Sign Out"
        }
        else if indexPath.row == 3{
            cell?.textLabel?.text = "Conversations"
        }
        
        
        return cell!
    }
    
    //if the cell is selected what should happen? e.g. when clicked call a particular viewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == 0
        {
            performSegue(withIdentifier: "map", sender: nil)
        }
        else if indexPath.row == 1
        {
             performSegue(withIdentifier: "message", sender: nil)
        }
        else if indexPath.row == 2{
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: GlobalVariables.KEY_UID)
        print("ID removed from keyhain : \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLoginScreen", sender: nil)
            
        }
        else if indexPath.row == 3
        {
            performSegue(withIdentifier: "friends", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }

}
