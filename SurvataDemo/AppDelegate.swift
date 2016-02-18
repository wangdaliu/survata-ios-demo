//
//  AppDelegate.swift
//  Demo
//
//  Created by Rex Sheng on 2/11/16.
//  Copyright © 2016 Survata. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		if TARGET_OS_SIMULATOR == 0 {
			BITHockeyManager.sharedHockeyManager().configureWithIdentifier("cc8f5f27308a471c804a6f9dc73eec5d")
			// Do some additional configuration if needed here
			BITHockeyManager.sharedHockeyManager().startManager()
			BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
		}
		return true
	}
}