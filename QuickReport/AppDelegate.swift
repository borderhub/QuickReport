//
//  AppDelegate.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import KeyClip

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appNavigationController: UINavigationController?
    
    //set keychain
    var token: String?
    
    // payload
    var payloadKeyData: Array<String> = []
    var payloadValueData: Array<String> = []
    var payload_flag = false
    
    // set a API key
    let applicationkey = "APPLICATIONKEY"
    let clientkey      = "CLIENTKEY"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // to request a devicetoken
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
            if error != nil {
                return
            }
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
            // flag
            payload_flag = true

            let key: Array! = Array(remoteNotification.allKeys)
            let value: Array! = Array(remoteNotification.allValues)
            
            if key != nil && value != nil {
                
                for i in 0..<key.count {
                    let key0 = key[i] as! String
                    payloadKeyData.append(key0)
                    
                    let value0 = String(describing: value[i])
                    payloadValueData.append(value0)
                    
                    print("<<device_log>>:key[\(key0)], value[\(value0)]")
                    
                }
                
            } else {
                print("<<device_log>>:can't get a payload")
                
            }
            
        }
        /*
         save　　　　　：KeyClip.save("access_token", string: "123456") // -> Bool
         setting　　　：let token = KeyClip.load("access_token") as String?
         delete　　　　：KeyClip.delete("access_token") // Remove the data
         clear　　　　：KeyClip.clear() // Remove all the data
         exist　　　　：KeyClip.exists("access_token") // -> Bool
         */
        
        if !KeyClip.exists("access_token") {
            KeyClip.save("access_token", string: "123456")
            token = (KeyClip.load("access_token") as String?)!
        } else {
        }
        
        let displayAppController: HomeController = HomeController()
        appNavigationController = UINavigationController(rootViewController: displayAppController)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = appNavigationController
        self.window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        print("Succeeded to get a devicetoken")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("error: " + "\(error)")
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch application.applicationState {
        case .inactive:
            // background
            break
        case .active:
            // When push notification is received at application startup
            break
        case .background:
            // When a push notification is received while the application is in the background
            break
        }
        
        payloadKeyData = []
        payloadValueData = []
        
        // Get Push Notification
        let key: Array! = Array(userInfo.keys)
        
        if key != nil {
            print(key)
            
            for i in 0..<key.count {
                let key0 = key[i] as! String
                let value0 = userInfo["\(key0)"]
                
                payloadKeyData.append(key0)
                
                if let unwrapValue = value0 {
                    if key0 == "aps" {
                        let apsUnwrapValue = String(describing: unwrapValue)
                        payloadValueData.append(apsUnwrapValue)
                    } else {
                        payloadValueData.append(unwrapValue as! String)
                    }
                    
                    print("key[\(key0)], value[\(unwrapValue)]")
                }
                
            }
            
        } else {
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "QuickReport")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
