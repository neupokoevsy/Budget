//
//  RecordMainTableViewCell.swift
//  Budget
//
//  Created by user on 26/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class RecordMainTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    func configureCell(record: Record) {
        self.amountLabel.text = String(describing: record.amount)
        self.categoryLabel.text = record.category
        self.typeLabel.text = record.type
        
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
//        let currencyCode = locale.currencyCode!
        let currencyCode = "$"
        currencyLabel.text = currencySymbol
        
        
        let date = record.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.dateLabel.text = dateFormatter.string(from: date!)
        
        if typeLabel.text == "Expense" {
            typeLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            typeLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }

}
