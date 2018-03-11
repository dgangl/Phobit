//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by LonoS on 21/01/2018.
//  Copyright © 2016 LonoS. All rights reserved.
//

import UIKit
import AVFoundation
import LocalAuthentication

class QRScannerController: UIViewController {
    
    
    
    
    
    //    @IBOutlet weak var backButton: UIButton!
    //    @IBOutlet var messageLabel:UILabel!
    //    @IBOutlet var topbar: UIView!
    var alreadyTookPhoto = false;
    var seen = false
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var gotIt = false
    var INPUT : String?
    var bill = BillData2(0.0)
    
    private let sessionQueue = DispatchQueue(label: "session queue") // Communicate with the session and other session objects on this queue.
    
    
    private var img : UIImage?
    
    let setting = EinstellungsController()
    
    @IBOutlet weak var whiteboard: UIImageView!
    @IBOutlet weak var hinweisText: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var camButton: UIButton!
    
    
    let cameraOutput = AVCapturePhotoOutput()
    let captureMetadataOutput = AVCaptureMetadataOutput()
    
    
    var captureDevice : AVCaptureDevice?
    
    
    
    
    
    
    private var supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    
    
    
    //Check viewDidLoad() for activating them!
    private let additionalCodeTypes = [AVMetadataObject.ObjectType.upce,
                                       AVMetadataObject.ObjectType.code39,
                                       AVMetadataObject.ObjectType.code39Mod43,
                                       AVMetadataObject.ObjectType.code93,
                                       AVMetadataObject.ObjectType.code128,
                                       AVMetadataObject.ObjectType.ean8,
                                       AVMetadataObject.ObjectType.ean13,
                                       AVMetadataObject.ObjectType.aztec,
                                       AVMetadataObject.ObjectType.pdf417,
                                       AVMetadataObject.ObjectType.itf14,
                                       AVMetadataObject.ObjectType.dataMatrix,
                                       AVMetadataObject.ObjectType.interleaved2of5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTorchMode()
        
        
        
        
        //ADD ALL CODE TYPES BY UNCOMMENTING THE FOLLOWING LINE//
        //supportedCodeTypes = supportedCodeTypes + additionalCodeTypes
        
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        do{
            try captureDevice.lockForConfiguration()
        }catch{print(error)}
        button.setTitle("Auto", for: UIControlState.normal)
        captureDevice.torchMode = AVCaptureDevice.TorchMode.auto
        captureDevice.unlockForConfiguration()
        
        self.captureDevice = captureDevice
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            do{
                try captureDevice.lockForConfiguration()
                captureSession.addOutput(cameraOutput)
                captureSession.addOutput(captureMetadataOutput)
            }catch{print("Error while adding Outputs: Complete Error Message here: \n \(error)")}
            captureDevice.unlockForConfiguration()
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        //        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: whiteboard)
        view.bringSubview(toFront: hinweisText)
        view.bringSubview(toFront: stack)
        view.bringSubview(toFront: button)
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    ////////////////////////
    // trying to fix a bug where the recognizer is running even we are in another view.
    ///////////////////////
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrCodeFrameView?.removeFromSuperview()
        self.captureSession.stopRunning()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        self.captureSession.startRunning()
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    @IBOutlet weak var button: UIButton!
    @IBAction func flashlight(_ sender: Any) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    button.setTitle("Off", for: UIControlState.normal)
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    //                    do {
                    //device?.torchMode = AVCaptureDevice.TorchMode.on
                    animateTorch(time: 0.1, flashLevel: 0.1)
                    button.setTitle("On", for: UIControlState.normal)
                    //                    } catch {
                    //                        print(error)
                    //                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
    }
    
    func animateTorch(time: Double, flashLevel: Float){
        
        let deadline = DispatchTime.now() + time
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            try device?.lockForConfiguration()
        }
        catch{print(error)}
        let flashMax : Float = 1.0
        if(flashLevel >= flashMax){
            print("Flash max!")
        }else{
            //Noch kleiner als FlashMax
            DispatchQueue.main.asyncAfter(deadline: deadline){
                do{
                    try device?.setTorchModeOn(level: flashLevel)
                    
                }catch {
                    print(error)
                }
                self.animateTorch(time: time, flashLevel: flashLevel + 0.1)
                
            }
        }
    }
    
    func checkTorchMode(){
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if(device?.torchMode == AVCaptureDevice.TorchMode.on){
            button.setTitle("On", for: UIControlState.normal)
        }
        else if(device?.torchMode == AVCaptureDevice.TorchMode.off){
            button.setTitle("Off", for: UIControlState.normal)
        }
    }
    
    
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the Objects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            // messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            //seen = false
            if metadataObj.stringValue != nil {
                if(metadataObj.stringValue!.contains("_R1") && seen == false){
                    seen = true
                    
                    capturePhoto()
                    shout()
                    
                    print("Saved")
                    let beleg = QRSplitter.split(qrCode: metadataObj.stringValue!)
                    setBeleg(bill: beleg)
                    //CameraButtonTabbed(self)
                    
                }else if(!metadataObj.stringValue!.contains("_R1")){
                    print("Fehlerhafter QR-Code im QRScannerController: QR-Code: \(metadataObj.stringValue)")
                    let alert = UIAlertController.init(title: "Kein Gültiger QR-Code.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when){
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }
                
                
                
            }
        }
    }
    
    
    
}

extension QRScannerController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        alreadyTookPhoto = false;
        seen = false;
        bill = BillData2(0.0)
        // activating session
        
        self.captureSession.startRunning()
    }
    
    
    
    
    
    func presentAuswertung(rechnung : BillData2) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Auswertung") as! AuswertungsTableViewController
        vc.bill = rechnung
        vc.image = img
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
        
        
    }
    
    
    func setBeleg(bill : BillData2){
        self.bill = bill
        print(self.bill.datum)
        
    }
    
    
    @IBAction func CameraButtonTabbed(_ sender: Any) {
        //Loading View
        let alert = UIAlertController(title: nil, message: "Bitte warten...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        //Time the View is loading
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            
            
            print("Datum: \(self.bill.datum)")
            if(self.bill.datum == "" || self.bill.gesamtBrutto == 0.0){
                loadingIndicator.removeFromSuperview()
                alert.message = "Wir konnten keinen passenden QR-Code finden"
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(animated: true, completion: nil)
                }
                
                
            }else{
                alert.dismiss(animated: true, completion: nil)
                self.presentAuswertung(rechnung: self.bill)
                print("Jump to Auswertung with: \(self.bill.datum) und \(self.bill.gesamtBrutto)")
            }
        }
        
        
        
        
    }
    
    
    
    @IBAction func SuchenButtonTabbed(_ sender: Any) {
        if(setting.getSliderState() == true){
            authentifizierung(seague: "suchen")
        }else if (setting.getSliderState() == false){
            self.performSegue(withIdentifier: "suchen", sender: nil)
        }else{
            print("Abgebrochen")
        }
        
        
    }
    
    @IBAction func settingsTabbed(_ sender: Any) {
        if(setting.getSliderState() == true){
            authentifizierung(seague: "einstellung")
        }else if (setting.getSliderState() == false){
            self.performSegue(withIdentifier: "einstellung", sender: nil)
        }else{
            print("Abgebrochen")
        }
    }
    
    
    func authentifizierung(seague : String) {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Authentifiziere dich um fortzufahren."
        
        
        var authError: NSError?
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        // Code did match
                        // continue
                        self.performSegue(withIdentifier: seague, sender: nil)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        
                        // Code did not match
                    }
                    
                }
            }
        } else {
            // No code on IPhone set
            // continue
            self.performSegue(withIdentifier: seague, sender: nil)
        }
        
        
    }
    
    
    
    
}
extension QRScannerController: AVCapturePhotoCaptureDelegate{
    
    
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
                             ]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
        print("Photo captured!" )
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(!alreadyTookPhoto){
            //            self.img = UIImage(cgImage: (photo.cgImageRepresentation()?.takeUnretainedValue())!)
            self.img = UIImage(cgImage: (photo.cgImageRepresentation()?.takeUnretainedValue())!, scale: 1, orientation: UIImageOrientation.right)
            alreadyTookPhoto = true;
        }
        
        
        print("Success")
        
        //print(img.size)
        
        
    }
    
    
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: NSError?) {
        print("Capture started")
        if let error = error {
            print("Error while taking the foto. Error Message: \(error.localizedDescription)")
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print("Cpatured")
            
            if let img = UIImage(data: dataImage){
                self.img = img
                print("success")
            }else{
                print("Error")
                
            }
        } else {
            
        }
    }
}
//TAP TO FOCUS
extension QRScannerController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let screenSize = view.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: view).y / screenSize.height, y: 1.0 - touchPoint.location(in: view).x / screenSize.width)
        
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
                
            } catch {
                // Handle errors here
            }
        }
    }
}


import Whisper
extension QRScannerController{
    func shout(){
        
        let announcement = Announcement(title: "Wir konnten einen Teil deiner Rechnung ausfüllen.", subtitle: "Zur Auswertung.", image: nil, duration: 30.0, action: {print("Pressed")})
        Whisper.show(shout: announcement, to: self, completion: {
            print("The shout was silent.")
        })
        
    }
}




