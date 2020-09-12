//
//  CategoryViewCell.swift
//  Budget
//
//  Created by Sergey Neupokoev on 04/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected && traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
                categoryTitle.textColor = UIColor.black
                categoryTitle.font.withSize(12)
                categoryImage.alpha = 1
            } else if isSelected && traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
               categoryTitle.textColor = UIColor.white
               categoryTitle.font.withSize(12)
               categoryImage.alpha = 1
            } else {
                categoryTitle.textColor = UIColor.gray
                categoryTitle.font.withSize(12)
                categoryImage.alpha = 0.3
            }
        }
    }
    
    func updateViews(category: Category){
        categoryImage.image = UIImage(named: category.imageName!)
        categoryTitle.text = category.title
    }
    
}
