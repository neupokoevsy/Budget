//
//  addNewCategoryVC.swift
//  Budget
//
//  Created by user on 12/09/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit

class addNewCategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    //******************************************************************
    //MARK: UI Outlets
    //******************************************************************

    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var newCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var newCategoryNameTextField: UITextField!
    
    //******************************************************************
    //MARK: Variables used
    //******************************************************************
    
    var newCategoryTitle: String? = ""
    var newCategoryImage: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categories = dataService.instance.getNewCategories()
        addButton.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()


        

        // Do any additional setup after loading the view.
    }
    
    
    //******************************************************************
    //MARK: CollectionView of new Categories to select from
    //******************************************************************
    
    
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
        newCategoryImage = category.imageName
    }
    
    
    //******************************************************************
    //MARK: Keyboard dismissal
    //******************************************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismiss(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func addCategoryButton(_ sender: UIButton) {
        newCategoryTitle = newCategoryNameTextField.text!
        if newCategoryTitle != nil && newCategoryTitle != "" {
            saveToCoreData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update"), object: nil)
            dismiss(animated: true, completion: nil)
        } else {
            newCategoryNameTextField.placeholder = "You should enter a name for category"
        }
    }
    
    
    //******************************************************************
    //MARK: Saving new category to CoreData
    //******************************************************************
    
    
    func saveToCoreData() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext
            else {
                return
        }
        let categoriesStored = Category(context: managedContext)
        categoriesStored.imageName = newCategoryImage
        categoriesStored.title = newCategoryTitle
        do {
            try managedContext.save()
            print("Sucessfully saved new category!")
        }
        catch {
            debugPrint("Could not save data. Error: \(error.localizedDescription)")
        }
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
