//
//  ExpenseVC.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit
import CoreData



class ExpenseVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //******************************************************************
    //MARK: Variables used
    //******************************************************************

    var dates = [String]()
    var weekDays = [String]()
    var months = [String]()
    var selectedDate: Int = 0
    var currentDate: Int = 0
    var categories: [Category] = []
    var indexPathForFirstRow = IndexPath(row: 0, section: 0)
    
    
    //******************************************************************
    //MARK: UI Outlets
    //******************************************************************
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var windowNameLabel: UILabel!
    
    
    override func viewDidLayoutSubviews() {
        indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
        self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLabelStyle()
        dataService.instance.fetchCoreDataObjects()
        categories = dataService.instance.categories
        dates = dataService.instance.arrayOfDates()
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchCoreDataObjectsWithNotification(notification:)), name: NSNotification.Name(rawValue: "Update"), object: nil)
        currentDate = dataService.instance.currentDateIndex
        indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
        print("IndexPATHForFirstRow \(indexPathForFirstRow)")
        self.setSelectedItemFromScrollView(CalendarCollectionView)
        self.CalendarCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        

    }
    
    
    //******************************************************************
    //MARK: Delete after finishing the project
    //******************************************************************
    
        func deleteAllCategories() {
            guard let managedContext = appDelegate?.persistentContainer.viewContext
                else {
                    return
                }
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
            } catch {
                print("Could not delete data: \(error.localizedDescription)")
            }
        }
    
        @objc func fetchCoreDataObjectsWithNotification(notification: NSNotification) {
            dataService.instance.fetchCoreDataObjects()
            categories = dataService.instance.categories
            categoriesCollectionView.reloadData()
        }
    
    //******************************************************************
    //MARK: Automatically select centered date
    //******************************************************************
    
        func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
                let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: (scrollView.center.y + scrollView.contentOffset.y))
                print(center)
                let index = CalendarCollectionView.indexPathForItem(at: center)
                if index != nil {
                    CalendarCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                    self.CalendarCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
                    self.selectedDate = (index?.row)!
                }
        }
    
    
    //******************************************************************
    //MARK: Little UI Tweaks :)
    //******************************************************************
    
    func changeLabelStyle() {
        windowNameLabel.text = "EXPENSE"
        windowNameLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.7503301056)
        windowNameLabel.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveButton.layer.cornerRadius = 5
    }
    
    
    
    
    
    //******************************************************************
    //MARK: CollectionView related code
    //******************************************************************
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CalendarCollectionView {
            let dates = dataService.instance.arrayOfDates()
            return dates.count
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.CalendarCollectionView {
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarViewCell
        cellA.dateLabel.text = dates[indexPath.row]
        return cellA
        } else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryViewCell
            let category = categories[indexPath.row]
            cellB.updateViews(category: category)
            return cellB
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CalendarCollectionView {
        print("Selected item at indexPath \(indexPath.row)")
        let selectedDate = dates[indexPath.row]
        print("Date chosen is \(selectedDate)")
        } else {
            let category = categories[indexPath.row]
            print("Selected category is: \(category.title!)")
            if category.title! == "New Category" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let addNewCategoryVc = storyboard.instantiateViewController(withIdentifier: "addNewCategoryVC") as! addNewCategoryVC
                self.present(addNewCategoryVc, animated: true) 
            }
        }
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setSelectedItemFromScrollView(CalendarCollectionView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setSelectedItemFromScrollView(CalendarCollectionView)
    }


}


//******************************************************************
//MARK: Extension of ExpenseViewController
//******************************************************************

extension ExpenseVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismiss(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
