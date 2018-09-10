//
//  AppearDisappearManager.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.09.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class AppearDisappearManager {
    /*
        IDs for the ViewControllers
        0 = Search
        1 = Camera
        2 = Settings
    */
    
    static func getAppearString(id: Int) -> String {
        return "\(id):appears"
    }
    
    static func getDisappearString(id: Int) -> String {
        return "\(id):disappears"
    }
    
    func update(new: Int, old: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppearDisappearManager.getAppearString(id: new)), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppearDisappearManager.getDisappearString(id: old)), object: nil)
    }
}
