//
//  ScanningViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 01.05.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import LocalAuthentication


class ScanningViewController: UIViewController {
    
//    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var blitzButton: UIButton!
    @IBOutlet weak var suchenSegueButton: UIButton!
    @IBOutlet weak var einstellungenSegueButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
//    @IBOutlet weak var whiteboard: UIImageView!
//    @IBOutlet weak var stackView: UIStackView!
    
    
    
    //InfoView
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var closeAndNeverShowUpAgain: UIButton!
    @IBOutlet weak var close: UIButton!
    
    
    // AVFoundation Stuff
    var sessionCanRun = false
    
    var session: AVCaptureSession? = AVCaptureSession.init()
    var device: AVCaptureDevice?
    var photoOutput = AVCapturePhotoOutput.init()
    
    var flashIsRunning = false
    // end
    
    
    
    // Vision stuff
    var requests = [VNRequest]()
    // end
    
    // overlay stuff and autoCapture
    let detectionOverlay = UIView()
    var overlay: Overlay?
    var autoCapture: AutoCaptureObservator?
    var canTakeNextQR = true
    // end
    
    
    // data to collect
    var billdata: BillData2?
    var image: UIImage?
    //end
    
    
    // else
    @IBOutlet weak var foundQRCodeBanner: UIView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(jumpToAuswertung(withImage:)))
        foundQRCodeBanner.addGestureRecognizer(tapRecognizer)
        
        
        let swipeToSearch = UISwipeGestureRecognizer.init(target: self, action: #selector(segueToSuchenBTN(_:)))
        let swipeToEinstellungen = UISwipeGestureRecognizer.init(target: self, action: #selector(segueToEinstellungenBTN(_:)))
        
        swipeToEinstellungen.direction = .left
        swipeToSearch.direction = .right
        
        
        
        self.view.addGestureRecognizer(swipeToSearch)
        self.view.addGestureRecognizer(swipeToEinstellungen)
        
        
        
        detectionOverlay.frame = view.frame
        detectionOverlay.center = view.center
        detectionOverlay.backgroundColor = UIColor.clear
        self.view.addSubview(detectionOverlay)
        
        overlay = Overlay.init(detectionView: detectionOverlay)
        
        sessionCanRun = checkForAuthorization()
        
        if sessionCanRun {
            setupSession()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overlay?.start()
        canTakeNextQR = true
        billdata = nil
        autoCapture?.resumeQR()
        autoCapture?.resumeStop()
        self.image = nil
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTheInfoView()
        
        
        
        if sessionCanRun == false {
            
            DispatchQueue.global().async {
                while true {
                    sleep(1)
                    self.sessionCanRun = self.checkForAutohizationSilent()

                    if self.sessionCanRun == true {
                        break
                    }
                    print("trying")
                }
                
                self.setupSession()
                self.session?.startRunning()
            }


        } else {
            if let session = session {
                session.startRunning()
            } else {
                print("error in settung up capture session.")
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        session?.stopRunning()
        overlay?.stop()
        blitzButton.setTitle("Aus", for: .normal)
        
        flashIsRunning = false
        
        do {
            try device?.lockForConfiguration()
            device?.torchMode = .off
            device?.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    
    func addTheInfoView(){
        let infoViewBool = UserDefaults.standard.bool(forKey: "infoView")
        if infoViewBool{
                
        }else if infoViewBool == false{
            infoView.center = self.view.center
            infoView.alpha = 0.0
            self.view.addSubview(infoView)
            UIView.animate(withDuration: 0.7) {
                self.infoView.alpha = 0.9
                self.infoView.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y - 10)
            }
            
        }
        
        
        
        
    }
    func removeInfoViewAnimation() -> Void{
        
        UIView.animate(withDuration: 0.8, animations:
            {   self.infoView.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y + 10)
                self.infoView.alpha = 0.0})
            {(result) in
                self.infoView.removeFromSuperview()
            }
        
    }
    
    
    @IBAction func showNeverAgain(_ sender: Any) {
        removeInfoViewAnimation()
        UserDefaults.standard.set(true, forKey: "infoView")
    }
    @IBAction func close(_ sender: Any) {
        removeInfoViewAnimation()
    }
    
    
    @IBAction func segueToSuchenBTN(_ sender: Any) {
        if getAuthStatus() == true {
            authentifizierung(seague: "suchen")
        } else {
            self.performSegue(withIdentifier: "suchen", sender: nil)
        }
    }
    
    @IBAction func segueToEinstellungenBTN(_ sender: Any) {
        if getAuthStatus() == true {
            authentifizierung(seague: "einstellungen")
        } else {
            self.performSegue(withIdentifier: "einstellungen", sender: nil)
        }
    }
    
    
    // authentication
    fileprivate func getAuthStatus() -> Bool{
        return UserDefaults.standard.bool(forKey: "slider")
    }

    
    fileprivate func authentifizierung(seague : String) {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Authentifiziere dich, um fortzufahren."
        var authError: NSError?
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        // Code did match
                        self.performSegue(withIdentifier: seague, sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        // Code did not match
                    }
                }
            }
        } else {
            // No code on iPhone set... we continue...
            self.performSegue(withIdentifier: seague, sender: nil)
        }
    }
    // authentication end
    
   
    @IBAction func cameraBTN(_ sender: Any) {
        captureImage()
    }
    
    @IBAction func toggleFlashBTN(_ sender: Any) {
        if flashIsRunning {
            do {
                try device?.lockForConfiguration()
                device?.torchMode = .off
                device?.unlockForConfiguration()
                flashIsRunning = false
                
                blitzButton.setTitle("Aus", for: .normal)
            } catch {
                print(error)
            }
        } else {
            do {
                try device?.lockForConfiguration()
                try device?.setTorchModeOn(level: 1)
                device?.unlockForConfiguration()
                flashIsRunning = true
                
                blitzButton.setTitle("Ein", for: .normal)
            } catch {
                print(error)
            }
        }
    }
    
    
    @objc func appMovedToBackground() {
        self.blitzButton.setTitle("Aus", for: .normal)
        self.billdata = nil
    }
}
