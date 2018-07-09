//
//  ScanningVision.swift
//  Phobit
//
//  Created by 73 on 01.05.18.
//  Copyright © 2018 73. All rights reserved.
//

import Vision

extension ScanningViewController {
    // note that the sample buffer delegate where the requests are made, is in the camerastuff file.
    
    func setupVision() {
        let rectangleDetection = VNDetectRectanglesRequest.init(completionHandler: handleRectangle)
        
        rectangleDetection.maximumObservations = 1
        rectangleDetection.minimumAspectRatio = 0
        
        // not really sure if this is ideal.
        rectangleDetection.minimumConfidence = 0.5
        
        
        self.requests.append(rectangleDetection)
        
        let qrDetection = VNDetectBarcodesRequest.init(completionHandler: handleBarcode)
        
        self.requests.append(qrDetection)
    }
    
    
    func handleRectangle(request: VNRequest, error: Error?) {
        guard let results = request.results else {
            print("There was an error with the request.")
            return
        }
        
        guard let result = results.first as! VNRectangleObservation? else {
            // kein ergebnis.
            overlay?.invisible()
            return
        }
        
        
        
        autoCapture?.feedWithNewValues(newTopLeft: result.topLeft, newTopRight: result.topRight, newBottomLeft: result.bottomLeft, newBottomRight: result.bottomRight)
        
        overlay?.updatePositionValues(topLeft: result.topLeft, topRight: result.topRight, bottomLeft: result.bottomLeft, bottomRight: result.bottomRight)
        
        if (autoCapture?.canTakeShot())! {
            autoCapture?.setStop()
            captureImage()
        }
    }
    
    func handleBarcode(request: VNRequest, error: Error?) {
        guard let results = request.results else {
            return
        }
        
        for result in results {
            let castedResult = result as! VNBarcodeObservation
            
            print(castedResult.payloadStringValue ?? "no value.")
            
            if let payload = castedResult.payloadStringValue {
                if payload.contains("_R1") && canTakeNextQR {
                    informUserAboutQR()
                    canTakeNextQR = false
                    autoCapture?.foundQR()
                    
                    billdata = QRSplitter.split(qrCode: payload)
                }
            }
        }
    }
}
