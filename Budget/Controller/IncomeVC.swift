//
//  IncomeVC.swift
//  Budget
//
//  Created by Sergey Neupokoev on 01/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class IncomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //******************************************************************
    //MARK: Variables used
    //******************************************************************
    
    var dates = [String]()
    var weekDays = [String]()
    var months = [String]()
    var selectedDateIndex: Int = 0
    var currentDate: Int = 0
    var indexPathForFirstRow = IndexPath(row: 0, section: 0)
    var date = Date()
    var amount: Double = 0.0
    let type: String = "Income"
    
    //******************************************************************
    //MARK: UI Outlets
    //******************************************************************

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var windowNameLabel: UILabel!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            changeLabelStyle()
            dates = dataService.instance.arrayOfDates()
            currentDate = dataService.instance.currentDateIndex
            indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
            self.setSelectedItemFromScrollView(CalendarCollectionView)
            self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
            self.CalendarCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
            self.hideKeyboardWhenTappedAround()
            date = Date()

            print("Current date index is: \(currentDate)")
        }
    
    //******************************************************************
    //MARK: Again little UI Tweaks :)
    //******************************************************************
    
    func changeLabelStyle() {
        windowNameLabel.text = "INCOME"
        windowNameLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        windowNameLabel.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveButton.layer.cornerRadius = 5
    }
        
        
    //******************************************************************
    //MARK: Automatically select centered date
    //******************************************************************
        
            func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
                    self.CalendarCollectionView.setNeedsLayout()
                    self.CalendarCollectionView.layoutIfNeeded()
                    let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: (scrollView.center.y + scrollView.contentOffset.y)-50)
                    print(center)
                    let index = CalendarCollectionView.indexPathForItem(at: center)
                    if index != nil {
                        CalendarCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                        self.CalendarCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
                        self.selectedDateIndex = (index?.row)!
                        print("Selected date index is: \(selectedDateIndex)")
                        let formatter = DateFormatter()
                        formatter.dateFormat = "YYYY-MM-DD"
                        let currentlySelectedDate = dataService.instance.arrayOfDatesForCoreData()[selectedDateIndex]
                        date = formatter.date(from: currentlySelectedDate) ?? Date()
                    }
            }
    
    //******************************************************************
    //MARK: CollectionView related code
    //******************************************************************
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let dates = dataService.instance.arrayOfDates()
            return dates.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarViewCell
            cell.dateLabel.text = dates[indexPath.row]
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("Selected item at indexPath \(indexPath.row)")
            let selectedDate = dates[indexPath.row]
            print("Date chosen is \(selectedDate)")
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            let currentlySelectedDate = dataService.instance.arrayOfDatesForCoreData()[indexPath.row]
            date = formatter.date(from: currentlySelectedDate) ?? Date()
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            setSelectedItemFromScrollView(CalendarCollectionView)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            setSelectedItemFromScrollView(CalendarCollectionView)
        }
        
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        amount = Double(amountTextField.text!) ?? 0.0
        if checkEntry() {
            saveNewToCoreData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRecordAdded"), object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func checkEntry() -> Bool {
        if amount == 0.0 || amountTextField.text == "" {
            amountTextField.shake()
            amountTextField.vibrate()
        } else if date == nil {
            CalendarCollectionView.shake()
            CalendarCollectionView.vibrate()
        } else {
            return true
        }
        return false
    }

    }

//******************************************************************
//MARK: Extension of IncomeViewController
//******************************************************************


extension IncomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismiss(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func saveNewToCoreData() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext
            else {
                return
        }
        let record = Record(context: managedContext)
        record.amount = amount
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


