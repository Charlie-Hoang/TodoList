//
//  AppDelegate.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: TLHomeCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initApp()
        
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        coordinator?.reFetchData()
    }
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate{
    private func initApp(){
            initApperance()
            initDB()
            let _ = TLNotificationService().requestPermission()
            UNUserNotificationCenter.current().delegate = self
    //        TLNotificationService().removeAll()
            if #available(iOS 13, *) { } else {
                let navController = UINavigationController()
                // send that into our coordinator so that it can display view controllers
                coordinator = TLHomeCoordinator(navigationController: navController)

                // tell the coordinator to take over control
                coordinator?.start()

                // create a basic UIWindow and activate it
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = navController
                window?.makeKeyAndVisible()
            }
        }
        private func initDB(){
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            if !launchedBefore{
                UserDefaults.standard.set(true, forKey: "launchedBefore")
                TLDBService().initialDB()
                TLNotificationService().removeAll()
            }
            TLNotificationService().getPendingNotificationIds { ids in
                print("PNTF: \(ids ?? [])")
            }
            TLNotificationService().getDeliveredNotificationIds { ids in
                print("DNTF: \(ids ?? [])")
            }
        }
        private func initApperance(){
            UINavigationBar.appearance().barTintColor = UIColor(red: 245/255, green: 195/255, blue: 84/255, alpha: 1.0)
        }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}
