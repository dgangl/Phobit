//
//  VisionHandler.swift
//  Anton
//
//  Created by Paul Wiesinger on 26.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation
import Vision
import UIKit
import AVFoundation


extension ScanningViewController {
    
    
    func handleRectangles(request: VNRequest, error: Error?) {
        // UI Changes habe to be performed on the main thread.
        DispatchQueue.main.sync {
            // deleting all older detection layers
            self.detectionView?.layer.sublayers?.removeSubrange(0...)
        }
        
        
        guard let observations = request.results else {
            DispatchQueue.main.async {
                print("Keine Rechtecke gefunden!")
            }
            return
        }
        
        let results = observations.map({$0 as? VNRectangleObservation})
        
        
        // getting only the first result.
        guard let result = results.first else {return}
        
        // UI Changes habe to be performed on the main thread.
        DispatchQueue.main.sync {
            
            if let result = result {
                
                self.drawOverlay(with: result)
                
                if rawTakenPhotoBuffer != nil {
                    var image = CIImage.init(cvImageBuffer: rawTakenPhotoBuffer!)
                    image = image.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                    print(image.extent.size)
                    
                    let imageSize = image.extent.size
                    let realSizeToScale = result.boundingBox.scaled(to: imageSize)
                    
                    
                    image = image.cropped(to: realSizeToScale).applyingFilter("CIPerspectiveCorrection", parameters: [
                        "inputTopLeft" : CIVector.init(cgPoint: result.topLeft.scale(to: imageSize)),
                        "inputTopRight" : CIVector.init(cgPoint: result.topRight.scale(to: imageSize)),
                        "inputBottomLeft" : CIVector.init(cgPoint: result.bottomLeft.scale(to: imageSize)),
                        "inputBottomRight" : CIVector.init(cgPoint: result.bottomRight.scale(to: imageSize))
                    ]).applyingFilter("CIColorControls", parameters: [
                            kCIInputSaturationKey: 0,
                            kCIInputContrastKey: 1
                    ]).applyingFilter("CIUnsharpMask").applyingFilter("CISharpenLuminance")
                    
                    rawTakenPhotoBuffer = nil
                    
                    
                    
                    /*
                    let imageView = UIImageView.init(frame: self.view.frame)
                    self.view.addSubview(imageView)
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage.init(ciImage: image)
                    */
                    
                    let context = CIContext(options: nil)
                    if let cgImage = context.createCGImage(image, from: image.extent) {
                        self.image = UIImage.init(cgImage: cgImage)
                        return
                    }
                    
                    
                }
                
            } else {
                // we got no result
                print("no result")
            }
        }
    }
     
    
    
    fileprivate func drawOverlay(with observation: VNRectangleObservation) {
        let path = CGMutablePath.init()
        
        let sizeToScale = (detectionView?.frame.size)!
        
        path.addLines(between: [observation.topLeft.scaledToUIKitCoordinatSystem(of: sizeToScale), observation.topRight.scaledToUIKitCoordinatSystem(of: sizeToScale), observation.bottomRight.scaledToUIKitCoordinatSystem(of: sizeToScale), observation.bottomLeft.scaledToUIKitCoordinatSystem(of: sizeToScale)])
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path
        shapeLayer.fillColor = UIColor.detectionOverlayColor.cgColor
        
        
        self.detectionView!.layer.addSublayer(shapeLayer)
    }
}
