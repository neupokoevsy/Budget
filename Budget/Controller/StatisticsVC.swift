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

}
