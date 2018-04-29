//
//  AppDelegate.swift
//  Phobit
//
//  Created by Paul Wiesinger on 09.12.17.
//  Copyright © 2017 Paul Wiesinger. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //WE ARE USING THIS FOR OUR DATABASE. DO NOT DELETE! VERY IMPORTANT
        FirebaseApp.configure();
        
        UserData.FIXED_DEMO_USER = UserDefaults.standard.object(forKey: "DemoUserUniqueNumber") as? String ?? ""
        
        //Initializing the User Data Array
        if (UserData.getWholeArray().count == 0 || UserData.getWholeArray().isEmpty) {
            let demo = UserData.init(name: "Demo Benutzer", email: "demomail@rzl.at", passwort: "DEMO", loginDate: Date.init(), uniqueString: UUID.init().uuidString);
            UserData.FIXED_DEMO_USER = demo.uniqueString;
            UserDefaults.standard.set(demo.uniqueString, forKey: "DemoUserUniqueNumber");
            UserData.addAccount(newUser: demo);
            print("Added the Demo Account")
        }
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        
        //Threading the demo datas
        DispatchQueue.global(qos: .background).async {
            self.appDidInstallAndFirstRun();
        }
        
        //Picking the Users Array
        let thisArray = UserData.getWholeArray();
        print(thisArray.count);
        
        //making the swipe
        let left = storyboard.instantiateViewController(withIdentifier: "Suchen")
        let middle = storyboard.instantiateViewController(withIdentifier: "camera")
        let right = storyboard.instantiateViewController(withIdentifier: "settings")
        
        
        let snapContainer = SnapContainerViewController.containerViewWith(left, middleVC: middle, rightVC: right)
        //makin the swipe end
        
        if (thisArray.count <= 1) /*Es ist nur der Demobenutzer vorhanden (Premium inactive)*/{
            UserDefaults.standard.set(true, forKey: "launching");
            
            //Saves the current Array to into the User Defaults
            UserData.saveNew(newArray: thisArray);
            
            
            //Zeige den Onboarding Screen
            vc = storyboard.instantiateViewController(withIdentifier: "BoardingScreen")
            //Adding the Base File
            
            
        }
        else/*Es wurde bereits ein User angelegt (Premium active)*/{
            //Zeige den mainScreen
            
            
            //Important for the UI of Onboarding Screen
            UserDefaults.standard.set(false, forKey: "launching");
        }
        
        self.window?.rootViewController = snapContainer;
        self.window?.makeKeyAndVisible()
        
        themeApp()
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
    
    /////////////////
    //OWN FUNCTIONS//
    /////////////////
    
    func appDidInstallAndFirstRun(){
        ////////////////////////////////////
        ////  FOR DEMO ACCOUNT ONLY!!!! ////
        ////////////////////////////////////
        
        // uncomment this method to activate sample data.

        if UserDefaults.standard.bool(forKey: "sampleDataLoaded") == false {
            
            SampleDataLoader.loadSampleData()
            UserDefaults.standard.set(true, forKey: "sampleDataLoaded")
            print("loaded Sample Data.")
            
        }
        
        
    } 
    
    func themeApp(){
        UINavigationBar.appearance().barTintColor = UIColor.rzlRed
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        
        

    }
}

