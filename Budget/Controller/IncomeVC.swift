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
    var selectedDate: Int = 0
    var currentDate: Int = 0
    
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
            let indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
            self.setSelectedItemFromScrollView(CalendarCollectionView)
            self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
            self.CalendarCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
            self.hideKeyboardWhenTappedAround()


            print("Current date index is: \(currentDate)")
        }
    
    override func viewDidLayoutSubviews() {
        let indexPathForFirstRow = IndexPath(row: currentDate, section: 0)
        self.setSelectedItemFromScrollView(CalendarCollectionView)
        self.CalendarCollectionView.scrollToItem(at: indexPathForFirstRow, at: .centeredHorizontally, animated: true)
        self.CalendarCollectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
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
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            setSelectedItemFromScrollView(CalendarCollectionView)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            setSelectedItemFromScrollView(CalendarCollectionView)
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
}


