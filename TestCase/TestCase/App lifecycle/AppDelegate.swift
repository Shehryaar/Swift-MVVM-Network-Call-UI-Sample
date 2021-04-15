//
//  AppDelegate.swift
//  TestCase
//
//  Created by Mac on 13/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var redirect : RedirectHelper!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        determineRoute()
        return true
    }
    
    func determineRoute() {
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        redirect = RedirectHelper(window: window)
        redirect.determineRoutes()
    }
}

