//
//  AppDelegate.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/23/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import UIKit
import Parse
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize Parse.
        Parse.setApplicationId("NAJHp52meLFwdQp8K3ONLzciWvZhwCgW4UIY83Yf",clientKey: "KgnW5QSyszCL7sc3QFnpLbEiXmIM2suI7epIpwCh")
        
        // Initialize Paypal
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentSandbox : "Abl04zRSa9e-DSmWHTa-cX_-r-SZuDgc8Q-hAodAvbZ4IZIvSeDHKnDXE-XKN2amdqyAVFHbSqE_VR5A"])
        
        // Initialize Stripe
        Stripe.setDefaultPublishableKey("pk_test_3XxYx4jpjSzItEdumkXpK17m")
        
        /*
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
            PayPalEnvironmentSandbox : @"YOUR_CLIENT_ID_FOR_SANDBOX"}];
        */
        
        // Override point for customization after application launch.
        //UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        let rootController = PhoneInfoViewController(viewModel: PhoneInfoViewModel())
        self.navigationController = UINavigationController(rootViewController:rootController)
        self.navigationController?.navigationBar.barTintColor = Colors.red
        self.navigationController?.navigationBar.tintColor = Colors.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.white]
        self.navigationController?.navigationBar.hidden = true
        
        self.window?.rootViewController =  navigationController
        self.window?.makeKeyAndVisible()
        debugPrint("didFinishLaunchingWithOptions")        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        debugPrint("application did become active")
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidBecomeActive", object: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

