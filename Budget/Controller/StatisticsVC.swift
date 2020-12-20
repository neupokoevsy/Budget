//
//  StatisticsVC.swift
//  Budget
//
//  Created by user on 21/11/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

public var dataReceivedForGraph = [Double]()

class StatisticsVC: UIViewController {
    
    //Label Outlets
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var graphView: StatisticsGraphView!
    @IBOutlet weak var lowDataLbl: UILabel!
    
    var filteredRecordsByCategories = [RecordParsed]()
    var filteredRecordsWithNonZeroAmount = [RecordParsed]()
    let records = dataService.instance.records
    var amount = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataReceivedForGraph = []
        filterRecordsByCategories()
        filterZeroAmount()
        print(dataReceivedForGraph)
        setupGraphDisplay()
        
        if dataReceivedForGraph.count >= 2 {
            graphView.isHidden = false
            lowDataLbl.isHidden = true
        } else {
            graphView.isHidden = true
            lowDataLbl.isHidden = false
        }
        
        
//        getDoublesFromRecordsParsed()
//        print(filteredRecordsByCategories)
        // Do any additional setup after loading the view.
    }
    
    func totalForEachCategory(searchItem: String) -> [RecordParsed] {
        var amount = [Double]()
        var computedAmount = 0.0
        let searchPredicate = NSPredicate(format: "category CONTAINS[C] %@", searchItem)
        let array = (records as NSArray).filtered(using: searchPredicate) as! [Record]
        for result in array {
            amount += amount.append(result.amount) as? [Double] ?? [0.0]
            let sum = amount.reduce(0, +)
            if sum != 0.0 {
                computedAmount = sum
//                print(computedAmount)
//                dataReceivedForGraph.append(computedAmount)
//                print(dataReceivedForGraph)
            }
        }
        return [RecordParsed.init(category: searchItem, amount: computedAmount)]
    }
    
    
    func filterRecordsByCategories(){
        dataService.instance.fetchCoreDataCategories()
        let categories = dataService.instance.categories
        for category in categories {
            filteredRecordsByCategories = totalForEachCategory(searchItem: String(category.title!))
            filteredRecordsWithNonZeroAmount.append(contentsOf: filteredRecordsByCategories)
        }
    }
    
    func filterZeroAmount() {
        
        for data in filteredRecordsWithNonZeroAmount{
//            print(data.amount)
            if data.amount != 0 {
                dataReceivedForGraph.append(data.amount)
            }
        }
    }
    
    func setupGraphDisplay() {
        let maxMonthIndex = stackView.arrangedSubviews.count - 1
        
        graphView.setNeedsDisplay()
        
        //Max label to be updated
        
        let maximum = dataReceivedForGraph.max()!
        print(maximum)

        maxLabel.text = "\(maximum)"
        
        let today = Date()
        let calenendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM")
        
        for i in 0...maxMonthIndex {
            if let date = calenendar.date(byAdding: .month, value: -i, to: today),
               let label = stackView.arrangedSubviews[maxMonthIndex - i] as? UILabel {
                label.text = formatter.string(from: date)
            }
        }
    }

}
