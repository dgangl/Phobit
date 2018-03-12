//
//  AppDelegate.swift
//  Phobit
//
//  Created by Paul Wiesinger on 09.12.17.
//  Copyright © 2017 Paul Wiesinger. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        
        
        
        var thisArray: [UserData] = [];
        
        if let data = UserDefaults.standard.data(forKey: "UserData"),
            let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue")
        }
        
        
        if (thisArray.isEmpty) {
            //Important for the UI of Onboarding Screen
            UserDefaults.standard.set(true, forKey: "launching");
            
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: thisArray)
            UserDefaults.standard.set(encodedData, forKey: "UserData");
            
            
            //Zeige den Onboarding Screen
            vc = storyboard.instantiateViewController(withIdentifier: "BoardingScreen")
            //Adding the Base File
            let f = File()
            f.saveFile(line: "", append: false, filename: "history")
            
        }
        else{
            //Zeige den mainScreen
            
            vc = storyboard.instantiateInitialViewController()!
            //Important for the UI of Onboarding Screen
            UserDefaults.standard.set(false, forKey: "launching");
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        
        
        
        ////////////////////////////////
        ////  FOR DEMO USE ONLY!!!! ////
        ////////////////////////////////
        
        // uncomment this method to activate sample data.
        
         if UserDefaults.standard.bool(forKey: "sampleDataLoaded") == false {
         SampleDataLoader.loadSampleData()
         UserDefaults.standard.set(true, forKey: "sampleDataLoaded")
         print("loaded Sample Data.")
         }
        
        
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
        
        // blur app in app switcher
        
        let blur = UIBlurEffect(style: .light)
        let visualEffektView = UIVisualEffectView(effect: blur)
        
        visualEffektView.frame = window!.frame
        
        visualEffektView.tag = 815
        
        self.window?.addSubview(visualEffektView)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.window?.viewWithTag(815)?.removeFromSuperview()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        self.window?.viewWithTag(0815)?.removeFromSuperview()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

