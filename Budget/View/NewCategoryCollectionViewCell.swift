//
//  NewCategoryCollectionViewCell.swift
//  Budget
//
//  Created by user on 12/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class NewCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newCategoryImage: UIImageView!
    
    
        override var isSelected: Bool {
        didSet {
            if isSelected {
                newCategoryImage.alpha = 1
            } else {
                newCategoryImage.alpha = 0.5
                }
            }
    }
    
    func updateViews(category: Categories){
        newCategoryImage.image = UIImage(named: category.imageName)
    }

    
}
