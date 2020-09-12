//
//  CategoryModel.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import Foundation

struct Categories {
    
    private(set) public var title: String
    private(set) public var imageName: String
    
    init(title: String, imageName: String) {
        self.imageName = imageName
        self.title = title
    }
    
//    init(category: Category) {
//        self.imageName = category.imageName!
//        self.title = category.title!
//    }
}


