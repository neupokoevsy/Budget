//
//  ViewController.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate


class MainVC: UIViewController {
    
    var addButton: UIButton?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustUI()
        self.navigationController?.view.addSubview(addButton!)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchCategoriesWithNotification(notification:)), name: NSNotification.Name(rawValue: "Update"), object: nil)
//        fetchCoreDataObjects()
//        deleteAllCategories()
//        printAllCategories()
    }
    
    



    
    func adjustUI() {
        addButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 + 90, y: self.view.frame.height - 120), size: CGSize(width: 70, height: 70)))
        addButton?.clipsToBounds = true
        addButton?.isHidden = false
        addButton!.setImage(UIImage(named: "AddButton_customImage.png"), for: .normal)
        addButton!.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Records"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

            @objc func addButtonPressed () {
            performSegue(withIdentifier: "addView", sender: self)

            }
//
//
//
//
//
//    func deleteAllCategories() {
//        guard let managedContext = appDelegate?.persistentContainer.viewContext
//            else {
//                return
//            }
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try managedContext.execute(deleteRequest)
//            try managedContext.save()
//        } catch {
//            print("Could not delete data: \(error.localizedDescription)")
//        }
//    }
//
//
//
//
//
//    func fetchCategories(completion: (_ complete: Bool) -> ()) {
//        guard let managedContext = appDelegate?.persistentContainer.viewContext
//            else {
//                return
//            }
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
//        let sort = NSSortDescriptor(key: "title", ascending: true)
//        fetchRequest.sortDescriptors = [sort]
//
//        do {
//            dataService.instance.categories = try managedContext.fetch(fetchRequest) as! [Category]
//            print("Fetched from CoreData Successfully")
//
//        }
//        catch
//            {
//            print("Could not fetch data: \(error.localizedDescription)")
//        }
//        }
//
//
//
//
//
//    func fetchCoreDataObjects() {
//        self.fetchCategories { (complete) in
//            if dataService.instance.categories.count == 0 {
//                print("NO CATEGORIES FOUND!")
//            } else {
//                print("CATEGORIES FOUND")
//            }
//        }
//    }
//
//
//
//    func save(completion: (_ finished: Bool ) -> ()) {
//    guard let managedContext = appDelegate?.persistentContainer.viewContext
//        else {
//                return
//                        }
//    let category = Category(context: managedContext)
//
//    do {
//        try managedContext.save()
//        completion(true)
//        print("Successfully saved data")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update"), object: nil)
//    }
//    catch {
//        debugPrint("Could not save. Error: \(error.localizedDescription)")
//        completion(false)
//    }
//
//}
//
//
//
//
//    func saveCategories() {
//            self.save(completion: {(complete) in
//                     if complete {
//                         dismiss(animated: true, completion: nil)
//                     }
//                 })
//        }
//}

}
