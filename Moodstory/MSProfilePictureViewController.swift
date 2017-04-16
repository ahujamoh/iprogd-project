//
//  MSProfilePictureViewController.swift
//  Moodstory
//
//  Created by Dora Palfi on 2017. 04. 16..
//  Copyright © 2017. MoodStory. All rights reserved.
//

import UIKit

class MSProfilePictureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editButton(_ sender: Any) {
        

        // 1
        let optionMenu = UIAlertController(title: nil, message: "Change pictur", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Take photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Open Camera")
        })
        let saveAction = UIAlertAction(title: "Choose from Camera Roll", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Open camera roll")
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
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
