//
//  ScanningVCMetadata.swift
//  Phobit
//
//  Created by Paul Wiesinger on 11.03.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation
import AVFoundation

extension ScanningViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {return}
        
        let myMeta = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if AVMetadataObject.ObjectType.qr == myMeta.type {
            
            if myMeta.stringValue != nil {
                if myMeta.stringValue!.contains("_R1") && gotQR == false {
                    gotQR = true
                    
                    // capture the photo
                    takePhoto = true
                    
                    // shout
                    informUserAboutQR()
                    
                    print("String:  \(myMeta.stringValue!)")
                    
                    billData = QRSplitter.split(qrCode: myMeta.stringValue!)
                    print(billData ?? "Keine Billdata! (Fehler im metadata Output)")
                }
            }
        }
        
    }
    
}
