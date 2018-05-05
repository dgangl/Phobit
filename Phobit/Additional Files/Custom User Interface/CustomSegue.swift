//
//  SeagueFromLeft.swift
//  Phobit
//
//  Created by Julian Kronlachner on 04.04.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit
class SegueFromLeft: UIStoryboardSegue {
    
    
    override func perform() {
        let src = self.source
        let dst = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        src.view.window?.layer.add(transition, forKey: nil)
        src.present(dst, animated: false, completion: nil)
    }
}



import UIKit
import QuartzCore

class SegueFromLeftNav: UIStoryboardSegue {
    
    override func perform() {
        let src: UIViewController = self.source
        let dst: UIViewController = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        src.navigationController!.view.layer.add(transition, forKey: kCATransition)
        src.navigationController!.pushViewController(dst, animated: false)
    }
}

