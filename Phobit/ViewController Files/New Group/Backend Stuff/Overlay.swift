//
//  Overlay.swift
//  Phobit
//
//  Created by Paul Wiesinger on 01.05.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class Overlay {
    
    var detectionView: UIView
    
    var timer: Timer? = nil
    
    
    var topLeft: CGPoint? = nil
    var topRight: CGPoint? = nil
    var bottomLeft: CGPoint? = nil
    var bottomRight: CGPoint? = nil
    
    fileprivate var updateTime: TimeInterval = 0.2
    fileprivate var shapeLayer = CAShapeLayer.init()
    
    fileprivate var isRunning = false
    fileprivate var wasPreviousInvisible = false
    
    
    
    
    init(detectionView: UIView) {
        self.detectionView = detectionView
        shapeLayer.fillColor = UIColor.detectionOverlayColor.cgColor
    }
    
    
    func stop() {
        isRunning = false
        timer?.invalidate()

        detectionView.layer.sublayers?.removeAll()
    }
    
    
    func start() {
        if !isRunning {

            shapeLayer.path = nil
            detectionView.layer.addSublayer(shapeLayer)

            timer = Timer.scheduledTimer(withTimeInterval: updateTime, repeats: true, block: { (timer) in
                self.update()
            })

            isRunning = true
        }
    }
    
    
    func updatePositionValues(topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        
       
        var sizeOptional: CGSize? = nil
        
        DispatchQueue.main.sync {
            sizeOptional = self.detectionView.frame.size
        }
        
        guard let size = sizeOptional else {return;}
        
        self.topLeft = topLeft.scaledToUIKitCoordinatSystem(of: size)
        self.topRight = topRight.scaledToUIKitCoordinatSystem(of: size)
        self.bottomLeft = bottomLeft.scaledToUIKitCoordinatSystem(of: size)
        self.bottomRight = bottomRight.scaledToUIKitCoordinatSystem(of: size)
        
        visible()
    }
    
    
    func invisible() {
        // clears all Layers from the Layer.
        let animation = CABasicAnimation.init(keyPath: "fillColor")
        animation.duration = 0.2
        animation.fromValue = shapeLayer.fillColor!
        animation.toValue = UIColor.clear.cgColor
        animation.timingFunction = CAMediaTimingFunction.init(name: "easeInEaseOut")

        shapeLayer.add(animation, forKey: "fillColor")

        // not sure if this will work...
        shapeLayer.isHidden = true

        wasPreviousInvisible = true
    }
    
    
    fileprivate func visible() {
        if wasPreviousInvisible {
            shapeLayer.isHidden = false
            shapeLayer.fillColor = UIColor.detectionOverlayColor.cgColor
        }
    }
    
    
    fileprivate func update() {
        //update the detection layer
        let path = CGMutablePath.init()

        guard let topLeft = topLeft, let topRight = topRight, let bottomRight = bottomRight, let bottomLeft = bottomLeft else {return;}

        path.addLines(between: [topLeft, topRight, bottomRight, bottomLeft])


        let animation = CABasicAnimation.init(keyPath: "path")
        animation.duration = 0.2
        animation.fromValue = shapeLayer.path
        animation.toValue = path
        animation.timingFunction = CAMediaTimingFunction.init(name: "easeInEaseOut")

        shapeLayer.add(animation, forKey: "path")
        shapeLayer.path = path
    }
}
