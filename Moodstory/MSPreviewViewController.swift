//
//  MSPreviewViewController.swift
//  Moodstory
//
//  Created by Mustafa Saeed on 4/9/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import Firebase

class MSPreviewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var capturedPhoto :UIImage!
    var pictureid : Int = 0
    var pic_duaration = 3
    var pickoption  = [1,2,3,4,5,6,7,8]
    var image_sending :UIImage!
    var test_image : UIImage!
    var lebel :UILabel!
    var lebel_test :UILabel!
    
    var isDrawing : Bool! = false
    var enabledrawing : Bool! = true
    var enabletexting : Bool! = true
    var enableemoji :Bool! = true
    var finalPoint: CGPoint!
    var lineWidth: CGFloat = 4.0
    
    let red: CGFloat = 255.0/255.0
    let green: CGFloat = 0.0/255.0
    let blue: CGFloat = 0.0/255.0
    let Indentifier = "sticker"
    var emojiList: [String] = []
    var LabelList: [UILabel] = []
    var lastRotation = CGFloat()
    
    @IBOutlet weak var ImageEdit: UIImageView!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var textOnImage: UITextView!
    @IBOutlet weak var imageText: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var durationPick: UIPickerView!
    @IBOutlet weak var allEmoji: UICollectionView!

    @IBOutlet weak var textX: NSLayoutConstraint!
    @IBOutlet weak var textY: NSLayoutConstraint!
    
    @IBAction func selectDuration(_ sender: Any) {
        self.durationPick.isHidden = false
    }
    
    @IBAction func quit(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendToServer(_ sender: UIButton) {
//        let image_original = self.captureScreen()
//        let image_sending = self.ResizeImage(image: image_original, targetSize: CGSize.init(width:305.0,height:600.0))
//        let sendtocontroller = SendToController()
//        let sending_image = SendingPhoto()
//        sending_image.image = image_sending
//        sending_image.timer = self.pic_duaration
//        sendtocontroller.photos.append(sending_image)
//        
//        let navController = UINavigationController(rootViewController: sendtocontroller)
//        present(navController, animated: true, completion: nil)
        
        print("sending logic to be implemented")
    }
    
    @IBAction func enableDraw(_ sender: UIButton) {
        
        if enabledrawing == true {
            enabledrawing = false
            self.ImageEdit.isUserInteractionEnabled = true
        }else {
            enabledrawing = true
            self.ImageEdit.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func imageEditText(_ sender: UIButton) {
        
        if enabletexting == true {
            enabletexting = false
            self.textOnImage.becomeFirstResponder()
            self.textOnImage.isHidden = false
        } else {
            enabletexting = true
            self.textOnImage.endEditing(true)
            self.textOnImage.isHidden = true
        }
        
    }
    
    @IBAction func showStickers(_ sender: UIButton) {
        
        if enableemoji == true {
            enableemoji = false
            self.allEmoji.isHidden = false
        }else{
            enableemoji = true
            self.allEmoji.isHidden = true
        }
    }
    
    @IBAction func emojiDrag(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        sender.view?.center = CGPoint(x:sender.view!.center.x+translation.x, y:sender.view!.center.y+translation.y)
        sender.setTranslation(CGPoint.init(x: 0.0, y: 0.0), in: self.view)
    }
    
    @IBAction func imageTextDrag(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        sender.view?.center = CGPoint(x:sender.view!.center.x, y:sender.view!.center.y+translation.y)
        sender.setTranslation(CGPoint.init(x: 0.0, y: 0.0), in: self.view)
        self.textX.constant += translation.x
        self.textY.constant += translation.y
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        durationPick.delegate = self
        ImageEdit.image = capturedPhoto
        self.durationPick.isHidden = true
        self.textOnImage.isHidden = true
        self.allEmoji.isHidden = true
        self.test.isHidden = true
        self.initEmoji()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ImageEdit.image = capturedPhoto
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ImageEdit.image = capturedPhoto
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveToFirebase() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        var username = String()
        
        // Create story reference
        let snapsRef = FIRDatabase.database().reference().child("snaps")
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                username = dictionary["name"] as! String
            }
        })
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("snaps").child(imageName)
        let image_original = self.captureScreen()
        let image_upload = self.ResizeImage(image: image_original, targetSize: CGSize.init(width:304,height:604))
        let uploadData = UIImagePNGRepresentation(image_upload)
        
        storageRef.put(uploadData!, metadata: nil, completion: { (metaData, error) in
            
            if error != nil {
                print(error as Any)
                return
            } else {
                
                // update database after successfully uploaded
                let snapRef = snapsRef.childByAutoId()
                if let imageURL = metaData?.downloadURL()?.absoluteString {
                    snapRef.updateChildValues(["userID": uid!, "username": username, "imageURL": imageURL, "timer": self.pic_duaration], withCompletionBlock: {(error, ref) in
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        
                        
                    })
                }
                
            }
            
        })
    }
    
    /**
     The method to realise drawing on image.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isDrawing = false
        self.durationPick.isHidden = true
        self.allEmoji.isHidden = true
        self.enableemoji = true
        
        if self.textOnImage.hasText
        {
            //self.ImageEdit.addSubview(self.text_on_image)
            self.enabletexting = true
            self.textOnImage.endEditing(false)
            
        } else {
            self.textOnImage.isHidden = true
            self.enabletexting = true
            self.textOnImage.endEditing(false)
            
        }
        self.textOnImage.endEditing(true)
        if let e = event?.touches(for: self.ImageEdit){
            if let touch = e.first {
                if #available(iOS 9.1, *) {
                    finalPoint = touch.preciseLocation(in: self.ImageEdit)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isDrawing = true
        if let e = event?.touches(for: self.ImageEdit){
            if let touch = e.first{
                if let d = self.ImageEdit {
                   let currentCoordinate = touch.preciseLocation(in: d)
                    
                    //UIGraphicsBeginImageContext(d.bounds.size)
                    UIGraphicsBeginImageContextWithOptions(d.bounds.size, false, 0.0)
                    d.image?.draw(in: CGRect.init(x: 0, y: 0, width: d.bounds.width, height: d.bounds.height))
                    UIGraphicsGetCurrentContext()?.move(to: finalPoint)
                    UIGraphicsGetCurrentContext()?.addLine(to: currentCoordinate)
                    UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
                    UIGraphicsGetCurrentContext()?.setLineWidth(lineWidth)
                    UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                    UIGraphicsGetCurrentContext()?.strokePath()
                    d.image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    finalPoint = currentCoordinate
                }
            }
        }
        
    }
    
    /**
     The method based on picker view delegate.
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickoption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "\(pickoption[row])second"}
        else {
            return "\(pickoption[row])seconds"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.pic_duaration = pickoption[row]
        self.durationPick.isHidden = true
    }
    
    /**
     The method to save image to core data.
     */
    func SaveImage(){
//        let saveQueue = DispatchQueue(label: "saveQueue",attributes: .concurrent)
//        saveQueue.async {
//            let image_original = self.captureScreen()
//            let image_sending = self.ResizeImage(image: image_original, targetSize: CGSize.init(width:375.0,height:604.0))
//            let imageData = UIImageJPEGRepresentation(image_sending, 1)
//            let contextManaged = self.getContext()
//            let a = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: contextManaged) as! Photo
//            a.photo_data = imageData as NSData?
//            a.timer = Int64(self.pic_duaration)
//            a.user_id = FIRAuth.auth()?.currentUser?.uid
//            print(a.user_id)
//            do {
//                try contextManaged.save()
//            } catch{
//                
//            }
//        }
//        self.pictureid += 1
//        self.save.isHidden = true
    }
    
    /**
     The method to resize image.
     */
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    /**
     The method to realise the final image.
     */
    func captureScreen() -> UIImage {
        self.ImageEdit.addSubview(self.textOnImage)
        self.ImageEdit.addSubview(self.test)
        UIGraphicsBeginImageContextWithOptions(self.ImageEdit.bounds.size, false,0.0);
        let context = UIGraphicsGetCurrentContext();
        self.ImageEdit.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    /**
     The method based on the collectionview delegate.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Indentifier, for: indexPath as IndexPath) as! MSStickerCell
        cell.emojiLabel.text = self.emojiList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You have selected cell #\(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let c:MSStickerCell = collectionView.cellForItem(at: indexPath) as! MSStickerCell
        self.test.text = c.emojiLabel.text
        self.test.isHidden = false
        self.allEmoji.isHidden = true
        self.enableemoji = true
    }
    
    /**
     The method translate emoji unicode into string.
     */
    func initEmoji(){
        for c in 0x1F601...0x1F64F{
            self.emojiList.append(String(describing: UnicodeScalar(c)!))
        }
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
