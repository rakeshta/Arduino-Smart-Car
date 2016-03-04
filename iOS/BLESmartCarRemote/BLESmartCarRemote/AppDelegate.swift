//
//  AppDelegate.swift
//  BLE Smart Car Remote
//
//  Created by Rakesh TA on 11/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift


@UIApplicationMain
class AppDelegate: UIResponder {
    
    // MARK: - Members
    
    var window: UIWindow?
}


// MARK: - Application Delegate

extension AppDelegate: UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Configure logging
        do {
            
            // Add logging detinations
            DDLog.addLogger(DDASLLogger.sharedInstance())
            DDLog.addLogger(DDTTYLogger.sharedInstance())
            
            // Enable colors
            DDTTYLogger.sharedInstance().colorsEnabled = true
            DDTTYLogger.sharedInstance().setForegroundColor(UIColor.grayColor(), backgroundColor: nil, forFlag: .Verbose)
        }
        
        return true
    }
}

