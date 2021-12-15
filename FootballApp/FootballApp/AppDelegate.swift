//
//  AppDelegate.swift
//  FootballApp
//
//  Created by Maxim V. Sidorov on 12/8/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                window.rootViewController = RootViewController()
            } else {
                window.rootViewController = RegistrationViewAssembly.createModule()
            }
            self.window = window
            window.makeKeyAndVisible()
        }
        
        SubscriptionManager.updateSubscriptions()
        
        return true
    }
}

