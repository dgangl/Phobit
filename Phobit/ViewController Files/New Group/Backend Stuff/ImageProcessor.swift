//
//  ImageEditor.swift
//  Phobit
//
//  Created by 73 on 01.05.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit
import Vision

class ImageProcessor {
    
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func process(completion: @escaping (Bool)->()) {
        let request = VNDetectRectanglesRequest.init { (request, error) in
            
            guard let result = request.results?.first else {
                // we failed
                completion(false)
                return
            }
            
            
            let castedResult = result as! VNRectangleObservation
            
            var image = CIImage.init(image: self.image)
            
            let imageSize = image?.extent.size
            let realSizeToScale = castedResult.boundingBox.scaled(to: CGSize.init(width: Int.init(imageSize!.width)-40, height: Int.init(imageSize!.height)-40))
            
            image = image?.cropped(to: realSizeToScale).applyingFilter("CIPerspectiveCorrection", parameters: [
                "inputTopLeft" : CIVector.init(cgPoint: castedResult.topLeft.scale(to: imageSize!)),
                "inputTopRight" : CIVector.init(cgPoint: castedResult.topRight.scale(to: imageSize!)),
                "inputBottomLeft" : CIVector.init(cgPoint: castedResult.bottomLeft.scale(to: imageSize!)),
                "inputBottomRight" : CIVector.init(cgPoint: castedResult.bottomRight.scale(to: imageSize!))
                ]).applyingFilter("CIColorControls", parameters: [
                    kCIInputSaturationKey: 0,
                    kCIInputContrastKey: 1.1,
                    kCIInputBrightnessKey: 0
                    ]).applyingFilter("CIExposureAdjust", parameters: [
                        kCIInputEVKey: 0.7
                        ])
            
            image = image?.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
            
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(image!, from: (image?.extent)!) {
                self.image = UIImage.init(cgImage: cgImage)
                
//                self.image = self.image.g8_blackAndWhite()


                completion(true)
            }

        }
        
        request.maximumObservations = 1
        request.minimumAspectRatio = 0
        request.minimumConfidence = 0.5
        
        
        
        let requestHandler = VNImageRequestHandler.init(ciImage: CIImage.init(image: self.image)!, options: [:])
        
        do{
            try requestHandler.perform([request])
        } catch {
            print(error)
        }
    }

    
    
    func getImage() -> UIImage {
        return image
    }
}
