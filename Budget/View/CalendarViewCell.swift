//
//  CalendarViewCell.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    override var isSelected: Bool {
        didSet {
//            if isSelected && self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
//                dateLabel.textColor = UIColor.white
//                dateLabel.font = UIFont.init(name: "Avenir-Heavy", size: 20)
//                weekDayLabel.textColor = UIColor.white
//            } else if isSelected && self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
//                dateLabel.textColor = UIColor.black
//                dateLabel.font = UIFont.init(name: "Avenir-Heavy", size: 20)
//                weekDayLabel.textColor = UIColor.black
//            } else {
//                dateLabel.font = UIFont.init(name: ("Avenir-Heavy"), size: 15)
//            }
//        }
            if isSelected{
                dateLabel.font = UIFont.init(name: "Avenir-Heavy", size: 18)
//                dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
            } else {
                dateLabel.font = UIFont.init(name: "Avenir-Heavy", size: 15)
//                dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
            }
        }
    }
    
    public enum Avenir: String {
    case avenir = "Avenir"
        case bold = "Avenir-Heavy"
        case book = "Avenir-Book"
        case medium = "Avenir-Medium"

        public func font(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
    
}
