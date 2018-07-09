//
//  Utilities.swift
//  Anton
//
//  Created by 73 on 26.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation
import UIKit


extension CGPoint {
    
    // used when we want to draw the preview layer.
    func scaledToUIKitCoordinatSystem(of size: CGSize) -> CGPoint {
        return CGPoint.init(x: self.x * size.width, y: (1 - self.y) * size.height)
    }
    
    // used when we scale the points for Perspective Correction.
    func scale(to size: CGSize) -> CGPoint {
        return CGPoint.init(x: self.x * size.width, y: self.y * size.height)
    }
}


extension CGRect {
    // used to scale the bounding box to the extent of the image.
    func scaled(to size: CGSize) -> CGRect {
        return CGRect(
            x: self.origin.x * size.width,
            y: self.origin.y * size.height,
            width: self.size.width * size.width,
            height: self.size.height * size.height
        )
    }
}
