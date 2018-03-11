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
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var gotIt = false
    var INPUT : String?
    var bill = BillData()
    
    let setting = EinstellungsController()
    
    @IBOutlet weak var whiteboard: UIImageView!
    @IBOutlet weak var hinweisText: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var camButton: UIButton!
    
    
   
    

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
        
        //ADD ALL CODE TYPES BY UNCOMMENTING THE FOLLOWING LINE//
        //supportedCodeTypes = supportedCodeTypes + additionalCodeTypes
        
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
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
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: whiteboard)
        view.bringSubview(toFront: hinweisText)
        view.bringSubview(toFront: stack)
      
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

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

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
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
            
            if metadataObj.stringValue != nil {
                
                if(metadataObj.stringValue!.contains("_R1")){
                    gotIt = true
                    print("Saved")
                    let beleg = QRSplitter.split(qrCode: metadataObj.stringValue!)
                    setBeleg(bill: beleg)
                }
                
                
            }
        }
    }
    
    
    
}

extension QRScannerController{
    
    
   
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        gotIt = false
        bill = BillData()
        
    }
    
    
  
    
    
    func presentAuswertung(rechnung : BillData) {
        gotIt = false
        
        var vc = storyboard?.instantiateViewController(withIdentifier: "Auswertung") as! NEWAuswertungsTableViewController
        
        vc.bill = rechnung
        
        let nvc = UINavigationController(rootViewController: vc)
        
        self.present(nvc, animated: true, completion: nil)
       
        
    }
    
    
    func setBeleg(bill : BillData){
        self.bill = bill
        print(self.bill.getDatum())
        
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
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            
            
            print("Datum: \(self.bill.getDatum())")
            alert.dismiss(animated: true, completion: nil)
            if(self.bill.getDatum() == "" || self.bill.getNetto() == 0.0){
                let alert = UIAlertController(title: nil, message: "Wir konnten keine Rechnung finden!", preferredStyle: .alert)
                alert.view.tintColor = UIColor(white: 1, alpha: 0.5)
                
                self.present(alert, animated: true, completion: nil)
                let dismissAfterTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: dismissAfterTime) {
                    alert.dismiss(animated: true, completion: nil)
                }
                
                
            }else{
                
                self.presentAuswertung(rechnung: self.bill)
                print("Jump to Auswertung with: \(self.bill.getDatum()) und \(self.bill.getNetto())")
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
