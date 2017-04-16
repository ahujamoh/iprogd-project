//
//  MSConversationsNavigationViewController.swift
//  Moodstory
//
//  Created by Mohit on 10/04/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "CellForCV"
class MSConversationsNavigationViewController: UINavigationController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionsView: UICollectionView!
    @IBOutlet var contactsView: UIView!
    let darkView = UIView.init()
    var items = [User]()
    var topAnchorContraint: NSLayoutConstraint!
    
    //MARK: methods to show and hide the view
    func customization(){
        //DarkView customization
        self.view.addSubview(self.darkView)
        self.darkView.backgroundColor = UIColor.black
        self.darkView.alpha = 0
        self.darkView.translatesAutoresizingMaskIntoConstraints = false
        self.darkView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.darkView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.darkView.isHidden = true
        //ContainerView customization
        let extraViewsContainer = UIView.init()
        extraViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(extraViewsContainer)
        self.topAnchorContraint = NSLayoutConstraint.init(item: extraViewsContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.topAnchorContraint.isActive = true
        extraViewsContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        extraViewsContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        extraViewsContainer.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        extraViewsContainer.backgroundColor = UIColor.clear
        //ContactsView customization
        extraViewsContainer.addSubview(self.contactsView)
        self.contactsView.translatesAutoresizingMaskIntoConstraints = false
        self.contactsView.topAnchor.constraint(equalTo: extraViewsContainer.topAnchor).isActive = true
        self.contactsView.leadingAnchor.constraint(equalTo: extraViewsContainer.leadingAnchor).isActive = true
        self.contactsView.trailingAnchor.constraint(equalTo: extraViewsContainer.trailingAnchor).isActive = true
        self.contactsView.bottomAnchor.constraint(equalTo: extraViewsContainer.bottomAnchor).isActive = true
        self.contactsView.isHidden = true
        self.collectionsView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.contactsView.backgroundColor = UIColor.clear
        //NotificationCenter for showing extra views
        NotificationCenter.default.addObserver(self, selector: #selector(self.showExtraViews(notification:)), name: NSNotification.Name(rawValue: "showExtraView"), object: nil)
        self.fetchUsers()
    }
    
    func dismissExtraViews(){
        self.topAnchorContraint.constant = 1000
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.darkView.alpha = 0
            self.view.transform = CGAffineTransform.identity
        }, completion:  { (true) in
            self.darkView.isHidden = true
            self.contactsView.isHidden = true
            let vc = self.viewControllers.last
            vc?.inputAccessoryView?.isHidden = false
        })
    }
    
    //Show extra view
    func showExtraViews(notification: NSNotification)  {
        let transform = CGAffineTransform.init(scaleX: 0.94, y: 0.94)
        self.topAnchorContraint.constant = 0
        self.darkView.isHidden = false
        if let type = notification.userInfo?["viewType"] as? ShowExtraView {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.darkView.alpha = 0.8
                if (type == .contacts || type == .profile) {
                    self.view.transform = transform
                }
            })
            switch type {
            case .contacts:
                self.contactsView.isHidden = false
                if self.items.count == 0 {
                    print("no item, lol")
                }
            default:
                print("you messed up real bad, should not have come here")
            }
        }
    }
    
    //Downloads users list for Contacts View
    func fetchUsers()  {
        if let id = FIRAuth.auth()?.currentUser?.uid {
            User.downloadAllUsers(exceptID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.collectionsView.reloadData()
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MSContactsCVCell
        //TODO: Mustafa: fix this to put the profile pic and name please
        cell.backgroundColor = UIColor.blue
        cell.profilePic?.image = self.items[indexPath.row].profilePic
        cell.nameLabel?.text = self.items[indexPath.row].name
        cell.profilePic?.layer.borderWidth = 2
        cell.profilePic?.layer.borderColor = GlobalVariables.purple.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.dismissExtraViews()
            let userInfo = ["user": self.items[indexPath.row]]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showUserMessages"), object: nil, userInfo: userInfo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (0.3 * UIScreen.main.bounds.width)
        let height = width + 30
        return CGSize.init(width: width, height: height)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismissExtraViews()
    }
    
    //MARK: delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        collectionsView.register(MSContactsCVCell.self, forCellWithReuseIdentifier: "CellForCV")
//        
//        self.collectionsView!.register(MSContactsCVCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.customization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.transform = CGAffineTransform.identity
    }
    
}
