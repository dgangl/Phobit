//
//  ProcessResult.swift
//  Phobit
//
//  Created by Paul Wiesinger on 01.05.18.
//  Copyright © 2018 LonoS. All rights reserved.
//


import UIKit

extension ScanningViewController {
    
    func gotImage() {
        
        self.session?.stopRunning()
        // webservice task here.
        // user information.
        // crop image.
        // filter image.
        
        
        let processor = ImageProcessor.init(image: self.image!)
        
        processor.process { (success) in
            
            let qrResult = self.isQRok()
            
            if success && qrResult {
                let webservice = WebService.init(image: processor.getImage())
                
                let tuple = self.showLoadingScreen(webservice: webservice)
                
                let progressView = tuple.0
                let alertView = tuple.1
                
                webservice.start(completion: { (response, statusCode) in
                    
                    UserDefaults.standard.removeObject(forKey: "OCRstring")
                    
                    print("###### completion started")
                    
                    if statusCode == WebServiceStatus.normal {
                        // perform with text in here.
                        let tag = Tagger.init()
                        if let rechnungsersteller = tag.recognizeOCR_Result(für: response) {
                            self.billdata?.rechnungsersteller = rechnungsersteller
                        }
                        UserDefaults.standard.set(response, forKey: "OCRstring")
                        // end
                        
                        alertView.dismiss(animated: true, completion: {
                            self.overlay?.invisible()
                            self.session?.startRunning()
                            self.jumpToAuswertung(withImage: processor.getImage())
                            
                            
                            self.cleanUp()
                        })
                    } else if statusCode == WebServiceStatus.systemCancelled || statusCode == WebServiceStatus.timeout {
                        // dissmissing the loading alertView...
                        alertView.dismiss(animated: true, completion: {
                            DispatchQueue.main.async {
                                self.overlay?.invisible()
                                self.cleanUp()
                            }
                            
                            
                            self.infromUserAboutWebserviceFailure(webservicestatus: statusCode)
                        })
   
                    } else {
                        // userCancelled...
                        
                        DispatchQueue.main.async {
                            self.cleanUp()
                            self.session?.startRunning()
                        }
                    }
                    
                }, progressView: progressView)
            } else {
                DispatchQueue.main.async {
                    self.session?.startRunning()
                    self.cleanUp()
                }
            }
        }
    }
    
    
    
    func cleanUp() {
        self.autoCapture?.resumeStop()
        self.autoCapture?.resumeQR()
        self.image = nil
        self.billdata = nil
        self.cameraButton.isEnabled = true
        self.canTakeNextQR = true
    }
    
    
    @objc func jumpToAuswertung(withImage correctedImage: UIImage?) {
        /*
        guard let billdata = billdata else {
            let alert = UIAlertController.init(title: "Keinen passenden QR-Code gefunden!", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let dispatchAfter = DispatchTime.now() + 2.5
            DispatchQueue.main.asyncAfter(deadline: dispatchAfter){
                alert.dismiss(animated: true, completion: nil)
            }
            
            return
        }
        */
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Auswertung") as! AuswertungsTableViewController
        
        vc.bill = billdata
        
        if let image = image {
            vc.image = correctedImage
        }
    
        let nvc = UINavigationController.init(rootViewController: vc)
        
        self.present(nvc, animated: true) {
            self.cameraButton.isEnabled = true
            self.autoCapture?.resumeQR()
            self.autoCapture?.resumeStop()
            self.billdata = nil
            self.foundQRCodeBanner.removeFromSuperview()
        }
    }
    
    
    func isQRok() -> Bool{
        
        guard billdata != nil else {
            let alert = UIAlertController.init(title: "Keinen passenden QR-Code gefunden!", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let dispatchAfter = DispatchTime.now() + 2.5
            DispatchQueue.main.asyncAfter(deadline: dispatchAfter){
                alert.dismiss(animated: true, completion: nil)
            }

            return false
        }
        
        return true
    }
}

