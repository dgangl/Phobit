//
//  CustomRoundedEffectView.swift
//  Phobit
//
//  Created by 73 on 11.03.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit

class CustomRoundedEffectView: UIVisualEffectView {

        override func layoutSubviews() {
            super.layoutSubviews()
            updateMaskLayer()
        }
        
        func updateMaskLayer(){
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
            self.layer.mask = shapeLayer
        }


}
