//
//  AutoCaptureObservator.swift
//  Phobit
//
//  Created by 73 on 29.04.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit
import AVFoundation

class AutoCaptureObservator {
    
    
    // the values of the vision rectangle detection.
    var topLeft: CGPoint?
    var topRight: CGPoint?
    var bottomLeft: CGPoint?
    var bottomRight: CGPoint?
    
    // counts the number of comparisons that were successfull within the tolerance
    var counter = 0
    
    // if there were n successfull comparisions we take the picture
    var snapValue = 5
    
    // the values that are compared have to be within this degree of deviations.
    var percentageTolerance: CGFloat = 0.03
 
    
    fileprivate var takeShot = false
    
    fileprivate var QRCodeFound = false
    
    fileprivate var stop = false
    
    fileprivate var device: AVCaptureDevice?
    
    
    init() {
        // empty...
    }
    
    
    // if we also want to track the focus of the device.
    init(device: AVCaptureDevice) {
        self.device = device
    }
    
    
    func feedWithNewValues(newTopLeft: CGPoint, newTopRight: CGPoint, newBottomLeft: CGPoint, newBottomRight: CGPoint) {
        
        guard let topLeft = topLeft, let topRight = topRight, let bottomLeft = bottomLeft, let bottomRight = bottomRight else {
            
            // initial setup
            self.topLeft = newTopLeft
            self.topRight = newTopRight
            self.bottomRight = newBottomRight
            self.bottomLeft = newBottomLeft
            
            return
        }
     
        var successfulCompared = false
        
        successfulCompared = topLeft.isEqualWithTolerance(otherPoint: newTopLeft, tolerance: percentageTolerance)
        successfulCompared = topRight.isEqualWithTolerance(otherPoint: newTopRight, tolerance: percentageTolerance)
        successfulCompared = bottomLeft.isEqualWithTolerance(otherPoint: newBottomLeft, tolerance: percentageTolerance)
        successfulCompared = bottomRight.isEqualWithTolerance(otherPoint: newBottomRight, tolerance: percentageTolerance)
        
        if successfulCompared == true {
            counter += 1
            
            if counter == snapValue {
                if let device = device {
                    // only if the device is currently not adjusting (which means it is focused) its focus we take the picture.
                    if device.isAdjustingFocus == false {
                        takeShot = true
                    }
                } else {
                    takeShot = true
                }
            }
            
        } else {
            // the difference of the values was to high. We start from the beginning.
            counter = 0
        }
        
        
        
        self.topLeft = newTopLeft
        self.topRight = newTopRight
        self.bottomRight = newBottomRight
        self.bottomLeft = newBottomLeft
        
    }
    
    
    /**
     Commands for the user like:
     "Bitte stillhalten."
     "Näher."
     "Schieße Foto."
     "Können leider nichts erkennen."
     oder nichts wenn kein Tipp gegeben wird.
    */
    func getMessageString() -> String? {
        
        if counter < snapValue {
            return "Stillhalten"
        } else if takeShot == true {
            return "Schieße Foto."
        }
        
        return nil
    }
    
    
    /*
        Tells if we can make a picture or not.
    */
    func canTakeShot() -> Bool {
        
        if stop == true {return false;}
        
        if takeShot == true && QRCodeFound == true {
            takeShot = false
            resumeQR()
            counter = 0
            
            return true
        } else {
            return false
        }
    }
    
    func setStop() {
        stop = true
    }
    
    func resumeStop() {
        stop = false
        counter = 0
    }
    
    func foundQR() {
        QRCodeFound = true
    }
    
    func resumeQR() {
        QRCodeFound = false
        counter = 0
    }
}






// adding some utils to CGPoint
extension CGPoint {
    
    
    /**
        You can use this tool to compare two CGPoints and give a tolerance for the comparision.
        Useful for Vision Object Tracking.
     
        *Values*
     
     
        `otherPoint` The Point you want to compare with
     
        `tolerance` The tolerance within the value of the other point can distinguish.
     
        - important: values for tolerance have to be between 0 and 1
    */
    func isEqualWithTolerance(otherPoint: CGPoint, tolerance: CGFloat) -> Bool {
        
        var lowerValueX = self.x * (1-tolerance)
        var upperValueX = self.x * (1+tolerance)
        
        var lowerValueY = self.y * (1-tolerance)
        var upperValueY = self.y * (1+tolerance)
        
        
        if lowerValueX < 0 || upperValueX < 0 {
            lowerValueX = lowerValueX * -1
            upperValueX = upperValueX * -1
        }
        
        if lowerValueY < 0 || upperValueY < 0 {
            lowerValueY = lowerValueY * -1
            upperValueY = upperValueY * -1
        }
        
        
        if lowerValueX...upperValueX ~= otherPoint.x {
            if lowerValueY...upperValueY ~= otherPoint.y {
                return true
            }
        }
        
        
        return false
    }
}
