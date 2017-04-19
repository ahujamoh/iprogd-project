//
//  MSConversationViewController.swift
//  Moodstory
//
//  Created by Mohit on 09/04/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellForConversation"

class MSConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var items = [Conversation]()
    var selectedUser: User?
    
    //Function to call when you want to access all the contacs
    func showContacts(){
        let info = ["viewType" : ShowExtraView.contacts]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    }
    
    
    @IBAction func showContactsAction(_ sender: Any) {
        self.showContacts()
    }
    
    func setUpConversationScreen(){
        //Notification setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
    }
    
    func fetchData(){
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        //                        self.playSound()
                        break
                    }
                }
            }
        }
    }
    
    //Shows Chat viewcontroller with given user
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segueToChat", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToChat" {
            let vc = segue.destination as! MSChatViewController
            vc.currentUser = self.selectedUser
        }
    }
    
    //MARK: Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "segueToChat", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MSConversationTableCellTableViewCell
        cell.clearCellData()
        cell.profilePic.image = self.items[indexPath.row].user.profilePic
        cell.nameLabel.text = self.items[indexPath.row].user.name
        switch self.items[indexPath.row].lastMessage.type {
        case .text:
            let message = self.items[indexPath.row].lastMessage.content as! String
            cell.messageLabel.text = message
        case .location:
            cell.messageLabel.text = "Location"
        default:
            cell.messageLabel.text = "Media"
        }
        let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
        let dataformatter = DateFormatter.init()
        dataformatter.timeStyle = .short
        let date = dataformatter.string(from: messageDate)
        cell.timeLabel.text = date
        if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
            cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
            cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
            cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
            cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
            cell.messageLabel.textColor = GlobalVariables.green
        }
        return cell
    }
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if revealViewController() != nil {
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
        self.setUpConversationScreen()
        self.fetchData()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: tableView cells made slidable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            self.items.remove(at: indexPath.row)
            
            self.tableView.reloadData()
        }
        print("removing item at \(indexPath.row)")
    }
    
}
