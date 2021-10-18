//
//  AppDelegate.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    var coordinator: VCCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let vc = ViewController()
        let navigation = UINavigationController(rootViewController: vc)
        coordinator = VCCoordinator(navigationController: navigation)
        
        coordinator?.delegate = vc
        vc.coordinator = coordinator

        window.rootViewController = navigation
        window.makeKeyAndVisible()
                
        return true
    }

}

