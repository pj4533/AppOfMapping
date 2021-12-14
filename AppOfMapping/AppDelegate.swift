//
//  AppDelegate.swift
//  AppOfMapping
//
//  Created by PJ Gray on 12/14/21.
//

import UIKit

// Where do I put these in Swift?
let playerCollisionMask : UInt32 = 0x1 << 1
let wallCollisionMask : UInt32 = 0x1 << 2


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // performance hit?
    var monsterDataSource : MonsterDataSource = SRDMonsterDataSource.shared
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        self.monsterDataSource.setEnvironmentFilter([])

        self.loadPersistedXMLData()
        
        if UserDefaults.standard.integer(forKey: "maxNumberRooms") == 0 {
            UserDefaults.standard.set(7, forKey: "maxNumberRooms")
            UserDefaults.standard.synchronize()
        }

        if let groupFilterData = UserDefaults.standard.object(forKey: "groupFilter") as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([MonsterGroup].self, from: groupFilterData) {
                self.monsterDataSource.setGroupFilter(decoded)
            }
        }

        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).tintColor = UIColor(red: 0.0, green: 0.431, blue: 0.827, alpha: 1.0)
        
        return true
    }

    func loadPersistedXMLData(){
        if let dataArray = UserDefaults.standard.object(forKey: "XMLData") as? [Data] {
            do {
                self.monsterDataSource = try GM5MonsterDataSource(dataArray: dataArray)
            } catch let error {
                print("Error reading XML data from disk: \(error.localizedDescription)")
            }
        }
    }
    
    func persistXMLData(_ data: Data) {
        
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
    }
    
}

