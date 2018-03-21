//
//  AppDelegate.swift
//  rpalkar03
//
//  Created by Rajesh Palkar on 3/18/18.
//  Copyright © 2018 Rajesh Palkar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
     
        let homeViewController = MovieListViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navigationController
        
        
        
        return true
    }

   


}

