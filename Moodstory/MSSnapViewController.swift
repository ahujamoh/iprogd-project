//
//  MSSnapViewController.swift
//  Moodstory
//
//  Created by Muhammad Mustafa Saeed on 3/18/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class MSSnapViewController: UIViewController {
    
    var usingSimulator: Bool = true
    var captureSession : AVCaptureSession!
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var currentDevice : AVCaptureDevice!
    var captureDeviceInputBack:AVCaptureDeviceInput!
    var captureDeviceInputFront:AVCaptureDeviceInput!
    var stillImageOutput:AVCaptureStillImageOutput!
    var cameraFacingback: Bool = true
    var ImageCaptured: UIImage!
    var cameraState:Bool = true
    var flashOn:Bool = false

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var Flash: UIButton!
    @IBOutlet weak var flipCamera: UIButton!
    
    @IBAction func jumpToChat(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var jumpToAddFriend: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        loadCamera()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        
        takePicButton.isEnabled = true;
        cameraState = false
        if !captureSession.isRunning {
            return
        }
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer,error) -> Void in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    self.ImageCaptured = UIImage(cgImage:cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    //self.captureSession.stopRunning()
                    self.performSegue(withIdentifier: "test", sender: self)}
            })
        }
    }

    @IBAction func changeFlash(_ sender: UIButton) {
        
        flashOn = !flashOn
        if flashOn {
//            self.Flash.setImage(UIImage(named: "Flashon"), for: UIControlState.normal)
        }
        else {
//            self.Flash.setImage(UIImage(named: "FlashOff"), for: UIControlState.normal)
        }
        self.configureFlash()
    }
    
    
    @IBAction func flipCamera(_ sender: UIButton) {
        
        cameraFacingback = !cameraFacingback
        if cameraFacingback {
            displayBackCamera()
//            self.flipCamera.setImage(UIImage(named:"Camera flip"), for: UIControlState.normal)
            
        } else {
            
//            self.self.flipCamera.setImage(UIImage(named:"Camera_flip_self"), for: UIControlState.normal)
            displayFrontCamera()
        }
    }
    
    @IBAction func goBackToMessageView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
     // MARK: - Camera Helper Functions
    
    func loadCamera() {
        captureSession = AVCaptureSession()
        captureSession.startRunning()
        
        if captureSession.canSetSessionPreset(AVCaptureSessionPresetHigh){
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        }
        let devices = AVCaptureDevice.devices()
        
        for device in devices! {
            if (device as AnyObject).hasMediaType(AVMediaTypeVideo){
                if (device as AnyObject).position == AVCaptureDevicePosition.back {
                    backCamera = device as! AVCaptureDevice
                }
                else if (device as AnyObject).position == AVCaptureDevicePosition.front{
                    frontCamera = device as! AVCaptureDevice
                }
            }
        }
        if backCamera == nil {
            print("The device doesn't have camera")
        }
        
        currentDevice = backCamera
        configureFlash()
        //var error:NSError?
        
        //create a capture device input object from the back and front camera
        do {
            captureDeviceInputBack = try AVCaptureDeviceInput(device: backCamera)
        }
        catch
        {
            
        }
        do {
            captureDeviceInputFront = try AVCaptureDeviceInput(device: frontCamera)
        }catch{
            
        }
        
        if captureSession.canAddInput(captureDeviceInputBack){
            captureSession.addInput(captureDeviceInputBack)
        } else {
            print("can't add input")
        }
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        let capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        capturePreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        capturePreviewLayer?.frame = self.view.frame
        
        capturePreviewLayer?.bounds = self.view.bounds
        
        previewView.layer.addSublayer(capturePreviewLayer!)
        
    }
    
    /**
     The method to load back camera.
     */
    func displayBackCamera(){
        if captureSession.canAddInput(captureDeviceInputBack) {
            captureSession.addInput(captureDeviceInputBack)
        } else {
            captureSession.removeInput(captureDeviceInputFront)
            if captureSession.canAddInput(captureDeviceInputBack) {
                captureSession.addInput(captureDeviceInputBack)
            }
        }
        
    }
    
    /**
     The method to load front camera.
     */
    func displayFrontCamera(){
        if captureSession.canAddInput(captureDeviceInputFront) {
            captureSession.addInput(captureDeviceInputFront)
        } else {
            captureSession.removeInput(captureDeviceInputBack)
            if captureSession.canAddInput(captureDeviceInputFront) {
                captureSession.addInput(captureDeviceInputFront)
            }
        }
    }
    
    func configureFlash(){
        do {
            try backCamera.lockForConfiguration()
        } catch {
            
        }
        if backCamera.hasFlash {
            if flashOn {
                if backCamera.isFlashModeSupported(AVCaptureFlashMode.on){
                    backCamera.flashMode = AVCaptureFlashMode.on
                }
            }else {
                if backCamera.isFlashModeSupported(AVCaptureFlashMode.off){
                    backCamera.flashMode = AVCaptureFlashMode.off
                    //flashOn = false
                }
                
            }
        }
        backCamera.unlockForConfiguration()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchpoint = touches.first
        //        var screenSize = previewView.bounds.size
        //        let location = touchpoint?.location(in: self.view)
        let x = (touchpoint?.location(in: self.view).x)! / self.view.bounds.width
        let y = (touchpoint?.location(in: self.view).y)! / self.view.bounds.height
        
        //        var locationX = location?.x
        //        var locationY = location?.y
        
        focusOnPoint(x: x, y: y)
    }
    
    /**
     The algorithm to reasise autofocus .
     */
    func focusOnPoint(x: CGFloat, y:CGFloat){
        let focusPoint = CGPoint(x: x, y: y)
        if cameraFacingback {
            currentDevice = backCamera
        }
        else {
            currentDevice = frontCamera
        }
        do {
            try currentDevice.lockForConfiguration()
        }catch {
            
        }
        
        if currentDevice.isFocusPointOfInterestSupported{
            
            currentDevice.focusPointOfInterest = focusPoint
        }
        if currentDevice.isFocusModeSupported(AVCaptureFocusMode.autoFocus)
        {
            currentDevice.focusMode = AVCaptureFocusMode.autoFocus
        }
        if currentDevice.isExposurePointOfInterestSupported
        {
            currentDevice.exposurePointOfInterest = focusPoint
        }
        if currentDevice.isExposureModeSupported(AVCaptureExposureMode.autoExpose) {
            currentDevice.exposureMode = AVCaptureExposureMode.autoExpose
        }
        currentDevice.unlockForConfiguration()
        
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "test"{
            let previewController = segue.destination as! MSPreviewViewController
            previewController.capturedPhoto = self.ImageCaptured
        }
    }

    
 

}
