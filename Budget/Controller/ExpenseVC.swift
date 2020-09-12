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

    var dates = [String]()
    var weekDays = [String]()
    var months = [String]()
    var selectedDate: Int = 0
    var currentDate: Int = 0
    var categories: [Category] = []

    
    
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var windowNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLabelStyle()
        dataService.instance.fetchCoreDataObjects()
        categories = dataService.instance.categories
        print("Total categories \(categories.count)")
        printAllCategories()
//        deleteAllCategories()

        
//        let category = dataService.instance.fillTheCategoriesWithInitialData(title: <#T##String#>, imageName: <#T##String#>)
        
        dates = dataService.instance.arrayOfDates()
        
//        let colView = CalendarCollectionView
//        print(colView?.frame.size)
        
        currentDate = dataService.instance.currentDateIndex
        let indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
        self.setSelectedItemFromScrollView(CalendarCollectionView)
        self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
        self.CalendarCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        

//        print("Current date index is: \(currentDate)")
    }
    
        func printAllCategories() {
            for category in categories {
                print(category.imageName as! String)
                print(category.title as! String)
            }
        }
    
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
    
        func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
                let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: (scrollView.center.y + scrollView.contentOffset.y)-50)
                print(center)
                let index = CalendarCollectionView.indexPathForItem(at: center)
                if index != nil {
                    CalendarCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                    self.CalendarCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
                    self.selectedDate = (index?.row)!
//                    print("Selected date index is: \(selectedDate)")
                }
        }
    
    
    func changeLabelStyle() {
        windowNameLabel.text = "EXPENSE"
        windowNameLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.7503301056)
        windowNameLabel.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dates = dataService.instance.arrayOfDates()
        return dates.count
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
        print("Selected item at indexPath \(indexPath.row)")
        let selectedDate = dates[indexPath.row]
        let selectedWeekDay = weekDays[indexPath.row]
        print("Date chosen is \(selectedDate), weekday is \(selectedWeekDay)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setSelectedItemFromScrollView(CalendarCollectionView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setSelectedItemFromScrollView(CalendarCollectionView)
    }
    
    
    
    

    
    
    

}
