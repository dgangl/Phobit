//
//  ScanningUserInformation.swift
//  Phobit
//
//  Created by Paul Wiesinger on 01.05.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

extension ScanningViewController {
    
    func errorWithCameraAuthorization() {
        let alert = UIAlertController.init(title: "Da stimmt etwas nicht!", message: "Wir können nicht auf deine Kamera zugreifen, da uns der Zugriff durch die Einstellungen verwährt wird. Gehe in die Einstellungen und erlaube uns den Zugriff auf deine Kamera.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "zu den Einstellungen", style: .default, handler: { (_) in
            UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func informUserAboutQR() {
        // present the sheet
        DispatchQueue.main.async {
            self.foundQRCodeBanner.alpha = 0
            self.foundQRCodeBanner.center = CGPoint.init(x: self.view.center.x, y: self.view.safeAreaInsets.top + 45)
            self.view.addSubview(self.foundQRCodeBanner)
            
            
            // animate in
            UIView.animate(withDuration: 0.3) {
                self.foundQRCodeBanner.alpha = 1
            }
            
            
            // animate out after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.foundQRCodeBanner.alpha = 0
                }, completion: { (success) in
                    self.foundQRCodeBanner.removeFromSuperview()
                    self.foundQRCodeBanner.alpha = 1
                    self.autoCapture?.resumeQR()
                    
                    if self.canDeleteQR {
                        // self.billdata = nil
                    }
                })
            }
        }
    }
    
    
    // returns the progress view for loading progress to fill with data.
    func showLoadingScreen() -> (UIProgressView, UIAlertController) {
        
        let alertView = UIAlertController(title: "Bitte warten", message: " ", preferredStyle: .alert)
        let progressView = UIProgressView.init()
        
        progressView.progress = 0
        
        progressView.frame = CGRect.init(x: 10, y: 60, width: 250, height: 0)
        
        alertView.view.addSubview(progressView)
        
        
        self.present(alertView, animated: true, completion: nil)
        
        return (progressView, alertView)
    }
}
