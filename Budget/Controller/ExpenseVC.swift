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
    var datesForCoreData = [String]()
    var weekDays = [String]()
    var months = [String]()
    var selectedDate: Int = 0
    var currentDate: Int = 0
    var categories: [Category] = []
    var indexPathForFirstRow = IndexPath(row: 0, section: 0)
    var amount: Double  = 0.0
    var currentlySelectedCategory: String = ""
    var date = Date()
    let type: String = "Expense"
    
    
    //******************************************************************
    //MARK: UI Outlets
    //******************************************************************
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var windowNameLabel: UILabel!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLabelStyle()
        dataService.instance.fetchCoreDataCategories()
        categories = dataService.instance.categories
        dates = dataService.instance.arrayOfDates()
        datesForCoreData = dataService.instance.arrayOfDatesForCoreData()
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchCategoriesWithNotification(notification:)), name: NSNotification.Name(rawValue: "Update"), object: nil)
        currentDate = dataService.instance.currentDateIndex
        indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
        self.setSelectedItemFromScrollView(CalendarCollectionView)
        self.CalendarCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    
//        override func viewDidLayoutSubviews() {
//            indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
//            self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
//        }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
        self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
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
    
        @objc func fetchCategoriesWithNotification(notification: NSNotification) {
            dataService.instance.fetchCoreDataCategories()
            categories = dataService.instance.categories
            categoriesCollectionView.reloadData()
        }
    
    //******************************************************************
    //MARK: Automatically select centered date
    //******************************************************************
    
        func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
                self.CalendarCollectionView.setNeedsLayout()
                self.CalendarCollectionView.layoutIfNeeded()
                let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: (scrollView.center.y + scrollView.contentOffset.y))
                print(center)
                let index = CalendarCollectionView.indexPathForItem(at: center)
                if index != nil {
                    CalendarCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                    self.CalendarCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
                    self.selectedDate = (index?.row)!
                    print("Selected date index is: \(selectedDate)")

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
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            let currentlySelectedDate = datesForCoreData[indexPath.row]
            date = formatter.date(from: currentlySelectedDate) ?? Date()
        } else {
            let category = categories[indexPath.row]
            print("Selected category is: \(category.title!)")
            currentlySelectedCategory = category.title!
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
    
    
    func checkEntry() -> Bool {
        if amount == 0.0 || amountTextField.text == "" {
            amountTextField.shake()
            amountTextField.vibrate()
        } else if currentlySelectedCategory == nil || currentlySelectedCategory == "" || currentlySelectedCategory == "New Category" {
            categoriesCollectionView.shake()
            categoriesCollectionView.vibrate()
        } else if date == nil {
            CalendarCollectionView.shake()
            CalendarCollectionView.vibrate()
        } else {
            return true
        }
        return false
    }
    
    
    
    @IBAction func saveRecordButtonPressed(_ sender: UIButton) {
        amount = Double(amountTextField.text!) ?? 0.0
        if checkEntry() {
            saveNewRecordsToCoreData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRecordAdded"), object: nil)
            dismiss(animated: true, completion: nil)
        } else {
            print("ENTER DETAILS")
        }
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
    
    //******************************************************************
    //MARK: Saving new category to CoreData
    //******************************************************************


    func saveNewRecordsToCoreData() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext
            else {
                return
        }
        let record = Record(context: managedContext)
        record.amount = amount
        record.category = currentlySelectedCategory
        record.date = date
        record.type = type
        record.comment = commentTextField.text ?? nil
        
        do {
            try managedContext.save()
            print("Sucessfully saved new record")
        }
        catch {
            debugPrint("Could not save data. Error: \(error.localizedDescription)")
        }
    }
}
