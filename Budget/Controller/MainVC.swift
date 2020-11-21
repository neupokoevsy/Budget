//
//  ViewController.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate


class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recordsView: UITableView!
    
    
    @IBOutlet weak var statisticsButton: UIBarButtonItem!
    var addButton: UIButton?
    var recordsFetched: [Record] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustUI()
        self.navigationController?.view.addSubview(addButton!)
        dataService.instance.fetchCoreDataRecords()
        recordsFetched = dataService.instance.records
        NotificationCenter.default.addObserver(self, selector: #selector(fetchRecordsWithNotification(notification:)), name: NSNotification.Name(rawValue: "NewRecordAdded"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addButton?.isHidden = false
    }
    

    //******************************************************************
    //MARK: AddButton creation and some UI adjustments
    //******************************************************************

    
    func adjustUI() {
        addButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 + 90, y: self.view.frame.height - 120), size: CGSize(width: 70, height: 70)))
        addButton?.clipsToBounds = true
        addButton?.isHidden = false
        addButton!.setImage(UIImage(named: "AddButton_customImage.png"), for: .normal)
        addButton!.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Records"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

            @objc func addButtonPressed () {
            performSegue(withIdentifier: "addView", sender: self)

            }
    
    @IBAction func statisticsButtonPressed(_ sender: Any) {
        addButton?.isHidden = true
        performSegue(withIdentifier: "showStatisticsVC", sender: self)
    }
    
    //**************************************
    //MARK: Hiding add button when scrolling
    //**************************************
    
    var lastContentOffset: CGFloat = 0
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            addButton?.isHidden = true
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            addButton?.isHidden = false
        }
    }
    
    
    //******************************************************************
    //MARK: TableView for records
    //******************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordsFetched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recordsView.dequeueReusableCell(withIdentifier: "recordsCell") as? RecordMainTableViewCell
        else {
            return UITableViewCell()
        }
        let record = recordsFetched[indexPath.row]
        cell.configureCell(record: record)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = true
        deleteAction.backgroundColor = UIColor.red
        return swipeConfig
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "DELETE") { (UIContextualAction, MainVC, completionHandler: (Bool) -> Void) in
            self.removeRecord(atIndexPath: indexPath)
            self.recordsView.deleteRows(at: [indexPath], with: .fade)
            dataService.instance.fetchCoreDataRecords()
            self.recordsFetched = dataService.instance.records
            completionHandler(true)
        }
        return action
    }
    
    //******************************************************************
    //MARK: Fetch CoreData when receive notification from other VC's
    //******************************************************************
    
    @objc func fetchRecordsWithNotification(notification: NSNotification) {
        dataService.instance.fetchCoreDataRecords()
        recordsFetched = dataService.instance.records
        recordsView.reloadData()
    }
    
    //******************************************************************
    //MARK: Delete selected CoreData record
    //******************************************************************
    
    
    func removeRecord(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext
        else
        {
            return
        }
        managedContext.delete(recordsFetched[indexPath.row])
        do {
            try managedContext.save()
            dataService.instance.fetchCoreDataRecords()
            self.recordsFetched = dataService.instance.records
//            print("successfully removed item at \(indexPath.row)")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
        
    }


}


