//
//  addNewCategoryVC.swift
//  Budget
//
//  Created by user on 12/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class addNewCategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    

    
    @IBOutlet weak var newCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var newCategoryNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categories = dataService.instance.getNewCategories()
        print(categories)

        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categories = dataService.instance.getNewCategories()
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCategoryCell", for: indexPath) as! NewCategoryCollectionViewCell
        let category = dataService.instance.getNewCategories()[indexPath.row]
        cell.updateViews(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = dataService.instance.getNewCategories()[indexPath.row]
        print(category.title)
        newCategoryNameTextField.placeholder = category.title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
