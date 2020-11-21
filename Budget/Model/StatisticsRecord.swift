//
//  StatisticsRecord.swift
//  Budget
//
//  Created by user on 21/11/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import Foundation


struct RecordParsed {
    var category: String
    var amount: Double
    
    init(category: String, amount: Double) {
        self.category = category
        self.amount = amount
    }
}
