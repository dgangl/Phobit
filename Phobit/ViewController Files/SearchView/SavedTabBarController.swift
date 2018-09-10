//
//  SavedTabBarController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.09.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class SavedTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor.rzlRed
        
        let myStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let searchVC = myStoryboard.instantiateViewController(withIdentifier: "Suchen") as! SuchenTableViewController
        let cachedVC = myStoryboard.instantiateViewController(withIdentifier: "Cached") as! CachedTableViewController
        
        let searchNVC = UINavigationController.init(rootViewController: searchVC)
        let cachedNVC = UINavigationController.init(rootViewController: cachedVC)
        
        searchNVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .recents, tag: 1)
        cachedNVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 2)
        
        viewControllers = [searchNVC, cachedNVC]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
