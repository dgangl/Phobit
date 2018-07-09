//
//  CustomToolbar.swift
//  Phobit
//
//  Created by 73 on 27.01.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit

class CustomToolbar {
    
    static func getAuswertungsToolbar(action: Selector, target: Any?) -> UIToolbar {
        
        let doneBTN = UIButton.init(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        doneBTN.tintColor = UIColor.white
        doneBTN.setTitle("Fertig", for: .normal)
        doneBTN.backgroundColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        doneBTN.layer.cornerRadius = 15
        doneBTN.addTarget(target, action: action, for: .touchUpInside)
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        
        // setting the toolbar to a transparent style
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem.init(customView: doneBTN)
        
        toolbar.items = [flex, done]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    
    
}
