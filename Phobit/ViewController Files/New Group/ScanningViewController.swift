//
//  ScanningViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 11.03.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import LocalAuthentication


class ScanningViewController: UIViewController {
    // small bug when i am in a phone call the green bar is minimizing the screen so that the detection layer is not accurat.
    var detectionView: UIView? = nil
    
    // vision Framework
    var requests = [VNRequest]()
    
    // AVFoundation
    var session = AVCaptureSession.init()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    var takeScan = false
    var rawTakenPhotoBuffer: CVImageBuffer?
    
    var gotQR = false
    var takePhoto = false

    var billData: BillData2?
    var image: UIImage?
    

    
    // items...
    @IBOutlet weak var flashToggle: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var whiteboard: UIImageView!
    
    
    @IBOutlet var informationSheet: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
        bringAllToFront()
        
        // configure informationSheet
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userTapedNotification))
        informationSheet.addGestureRecognizer(tapRecognizer)
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.session.stopRunning()
        self.flashToggle.setTitle("Aus", for: .normal)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.session.startRunning()
        
        self.image = nil
        self.billData = nil
        

    }
    
    
    func bringAllToFront() {
        self.view.bringSubview(toFront: whiteboard)
        self.view.bringSubview(toFront: flashToggle)
        self.view.bringSubview(toFront: stackView)
        self.view.bringSubview(toFront: infoLabel)
        
    }
    
    
    
    
    
    private func setupCamera() {
        // basic setup
        session.sessionPreset = AVCaptureSession.Preset.photo
        captureDevice = AVCaptureDevice.default(for: .video)
        
        guard let myDevice = captureDevice else {print("Konnte keine Kamera finden"); return}
        
        do {
            try myDevice.lockForConfiguration()
        
        // adding input
        let deviceInput = try! AVCaptureDeviceInput.init(device: myDevice)
        let deviceOutput = AVCaptureVideoDataOutput.init()
        
        
//        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        //QR-Code Metadata Output
        let metadataoutput = AVCaptureMetadataOutput()

        
        
        // adding it to the session
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        session.addOutput(metadataoutput)
            myDevice.unlockForConfiguration()
            
            metadataoutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataoutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            print(error)
        }
        
        // previewLayer
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = self.view.bounds
        
        self.view.layer.addSublayer(previewLayer!)
//        session.startRunning()
    }
    
    
    
    private func setupVision() {
        let rectangleDetection = VNDetectRectanglesRequest.init(completionHandler: self.handleRectangles)
        rectangleDetection.maximumObservations = 1
        rectangleDetection.minimumAspectRatio = 0
        
        // not really sure if this is ideal.
        rectangleDetection.minimumConfidence = 0.5
        
        
        self.requests = [rectangleDetection]
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    // dissmisses the QR Code after 7 seconds
    func informUserAboutQR() {
        // present the sheet
        
        informationSheet.alpha = 0
        informationSheet.center = CGPoint.init(x: self.view.center.x, y: self.view.safeAreaInsets.top + 45)
        self.view.addSubview(informationSheet)
        
        
        // animate in
        UIView.animate(withDuration: 0.3) {
            self.informationSheet.alpha = 1
        }
        
        
        // animate out after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.informationSheet.alpha = 0
            }, completion: { (success) in
                self.informationSheet.removeFromSuperview()
                self.informationSheet.alpha = 1
                self.gotQR = false
            })
        }
    }
    
    
    
    @objc func userTapedNotification() {
        // performSegue from QR notification
        jumpToAuswertung()
    }
    
    
    func jumpToAuswertung() {
        guard let bill = self.billData else {return}
        guard let image = self.image else {return}
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Auswertung") as! AuswertungsTableViewController
        
        vc.bill = bill
        vc.image = image
        
        let nvc = UINavigationController.init(rootViewController: vc)
        
        self.present(nvc, animated: true) {
            // TODO: clean up user interface.
            self.informationSheet.removeFromSuperview()
            self.takeScan = false
            self.takePhoto = false
//            self.image = nil
        }
    }
    
    
    
    
    
    // buttons
    @IBAction func cameraButtonTabbed(_ sender: UIButton) {
        takeScan = true
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.jumpToAuswertung()
        }
    }
    
    
    
    @IBAction func flashButtonToggle(_ sender: UIButton) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    flashToggle.setTitle("Aus", for: UIControlState.normal)
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    animateTorch(time: 0.05, flashLevel: 0.1)

                    flashToggle.setTitle("Ein", for: UIControlState.normal)
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
    
    
    
    
    
    
    
    
    
    @IBAction func toSettingTabbed(_ sender: UIButton) {
        if getAuthStatus() == true {
            authentifizierung(seague: "einstellungen")
        } else {
            performSegue(withIdentifier: "einstellungen", sender: nil)
        }
    }
    
    
    
    @IBAction func toSearchViewTabbed(_ sender: UIButton) {
        if getAuthStatus() == true {
            authentifizierung(seague: "suchen")
        } else {
            performSegue(withIdentifier: "suchen", sender: nil)
        }
    }
    
    
    fileprivate func getAuthStatus() -> Bool{
        return UserDefaults.standard.bool(forKey: "slider")
    }
    
    
    fileprivate func authentifizierung(seague : String) {
        
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









extension ScanningViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        if detectionView == nil {
            // setup the detection layer. (only on the first call of this method)
            
            // NOTE: For information about the calculation see: Note number 2 in the Support Doc.
            
            
            let image = CIImage.init(cvPixelBuffer: CMSampleBufferGetImageBuffer(sampleBuffer)!).oriented(CGImagePropertyOrientation.right)
            
            // changes on the UI have to be performed on the main block.
            DispatchQueue.main.sync {
                let calculationFactor = self.view.frame.height/image.extent.height
                
                let detectionViewHeight = image.extent.height * calculationFactor
                let detectionViewWidth = image.extent.width * calculationFactor
                
                detectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: detectionViewWidth, height: detectionViewHeight))
                detectionView?.center = self.view.center
                
                detectionView?.backgroundColor = UIColor.clear
                
                self.view.addSubview(detectionView!)
                
                // bringing the other views to the front, so that they are touchable again
                bringAllToFront()
            }
            
            // we dont want to do anything else... We could so, but we just dont't do it, otherwise some frames would drop...
            return
        }
        
        
        var options: [VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            options = [.cameraIntrinsics : camData]
        }
        
        
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let requestHandler = VNImageRequestHandler.init(cvPixelBuffer: pixelbuffer, orientation: CGImagePropertyOrientation.init(rawValue: 6)!, options: options)
        
        do {
            // if we want to take a photo
            if takeScan {
                // the handler will work if this was set.
                rawTakenPhotoBuffer = pixelbuffer
                
                // no other threads should go into this.
                takeScan = false
            }
            
            if takePhoto {
                takePhoto = false
                let ciimage = CIImage.init(cvImageBuffer: pixelbuffer).oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let context = CIContext(options: nil)
                if let cgImage = context.createCGImage(ciimage, from: ciimage.extent) {
                    image = UIImage.init(cgImage: cgImage)
                    return
                }
//
//                image = UIImage.init(ciImage: CIImage.init(cvImageBuffer: pixelbuffer).oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue)))
            }
            
            try requestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    
    
    
    // tap to focus
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

