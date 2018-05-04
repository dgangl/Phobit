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
        // webservice task here.
        // user information.
        // crop image.
        // filter image.
        
        
        let processor = ImageEditor.init(image: self.image!)
        
        processor.process { (success) in
            if success {
                let webservice = WebService.init(image: processor.getImage())
                
                let tuple = self.showLoadingScreen()
                
                let progressView = tuple.0
                let alertView = tuple.1
                
                webservice.start(completion: { (response, statusCode) in
                    
                    print("###### completion started")
                    
                    if statusCode == 200 {
                        // perform with text in here.
                        
                        
                        // end
                        
                        alertView.dismiss(animated: true, completion: {
                            self.jumpToAuswertung(withImage: processor.getImage())
                        })
                    }
                }, progressView: progressView)
            }
            
            self.cameraButton.isEnabled = true
            self.canDeleteQR = true
        }
    }
    
    
    
    func jumpToAuswertung(withImage correctedImage: UIImage) {
        
        guard let billdata = billdata else {
            let alert = UIAlertController.init(title: "Keinen passenden QR-Code gefunden!", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let dispatchAfter = DispatchTime.now() + 2.5
            DispatchQueue.main.asyncAfter(deadline: dispatchAfter){
                alert.dismiss(animated: true, completion: nil)
            }
            
            return
        }
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Auswertung") as! AuswertungsTableViewController
        
        vc.bill = billdata
        vc.image = correctedImage
        
        let nvc = UINavigationController.init(rootViewController: vc)
        
        self.present(nvc, animated: true) {
            self.cameraButton.isEnabled = true
            self.autoCapture?.resumeQR()
            self.autoCapture?.resumeStop()
            self.billdata = nil
            self.foundQRCodeBanner.removeFromSuperview()
        }
    }
}
