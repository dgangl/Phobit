//
//  ScanningViewController.swift
//  Phobit
//
//  Created by 73 on 01.05.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit
import AVFoundation
import Vision


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
    
    
    var blackView : UIView?
    var blurView : UIVisualEffectView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("----- START NEURAL NET OUTPUT -----")
        _ = NeuralNet();
        print("----- END NEURAL NET OUTPUT -----")
        
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(jumpToAuswertungWithQR))
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
        
        
        if sessionCanRun {
            if let session = session {
                session.startRunning()
            } else {
                print("error in settung up capture session.")
            }
        }
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
            /*
            if let session = session {
                session.startRunning()
            } else {
                print("error in settung up capture session.")
            }
            */
        }
        
        
        // we call it here in general. so it will work in the simulator too.
        bringAllElementsToFront()
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
            let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
            blurView = UIVisualEffectView(effect: darkBlur)
            blurView!.frame = self.view.frame
            blurView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView!.alpha = 0.0
            
            
            blackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            blackView?.backgroundColor = .black
            blackView?.alpha = 0.0
            
            self.view.addSubview(blurView!)
            self.view.addSubview(blackView!)
            UIView.animate(withDuration: 0.7){
                self.blackView?.alpha = 0.7
                self.blurView?.alpha = 0.7
            }
            
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
        
       
        UIView.animate(withDuration: 0.8, animations: {
            self.blackView?.alpha = 0.0
            self.blurView?.alpha = 0.0
        }){(result) in
            self.blackView?.removeFromSuperview()
            self.blurView?.removeFromSuperview()
        }
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
//        if getAuthStatus() == true {
//            authentifizierung(seague: "suchen")
//        } else {
//            AppDelegate.snapContainer.scrollToPage(0)
////            self.performSegue(withIdentifier: "suchen", sender: nil)
//        }
        
        
        Authentifizierung.scrollAndCheck(toID: 0)
    }
    
    @IBAction func segueToEinstellungenBTN(_ sender: Any) {
        Authentifizierung.scrollAndCheck(toID: 2)
    }
    
    
   
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
