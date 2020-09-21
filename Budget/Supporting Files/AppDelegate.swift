//
//  AppDelegate.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //******************************************************************
        //MARK: Initial categories created upon installation of the App
        //******************************************************************
        
        let userDefaults = UserDefaults.standard
        let defaultValues = ["firstRun" : true]
        userDefaults.register(defaults: defaultValues)
        
        if userDefaults.bool(forKey: "firstRun") {
            let initialCategories = [
            Categories(title: "Beauty", imageName: "beauty.png"),
            Categories(title: "Car", imageName: "car.png"),
            Categories(title: "Clothes", imageName: "clothes.png"),
            Categories(title: "Electronics", imageName: "electronics.png"),
            Categories(title: "Food", imageName: "food.png"),
            Categories(title: "Gifts", imageName: "gifts.png"),
            Categories(title: "Hobby", imageName: "hobby.png"),
            Categories(title: "Hospital", imageName: "hospital.png"),
            Categories(title: "Household", imageName: "household.png"),
            Categories(title: "Lunch", imageName: "lunch.png"),
            Categories(title: "Online Shopping", imageName: "online_shopping.png"),
            Categories(title: "Pharmacy", imageName: "pharmacy.png"),
            Categories(title: "Activity", imageName: "sport.png"),
            Categories(title: "Transport", imageName: "transportation.png"),
            Categories(title: "Utility Payments", imageName: "utility_payments.png"),
            Categories(title: "Vacation", imageName: "vacation.png"),
            Categories(title: "Work", imageName: "work.png"),
            Categories(title: "Other", imageName: "other.png"),
            Categories(title: "New Category", imageName: "newCategory.png")
            ]
            let managedContext = (appDelegate?.persistentContainer.viewContext)!
            let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
            for cat in initialCategories {
                let category = NSManagedObject(entity: entity, insertInto: managedContext)
                category.setValue(cat.imageName, forKey: "imageName")
                category.setValue(cat.title, forKey: "title")
                }
            do {
                try managedContext.save()
                userDefaults.set(false, forKey: "firstRun")
            }
            catch {
                debugPrint("Could not save. Error: \(error.localizedDescription)")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Budget")
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

