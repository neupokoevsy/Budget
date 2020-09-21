//
//  DataService.swift
//  Budget
//
//  Created by user on 25/08/2020.
//  Copyright © 2020 Sergey Neupokoev. All rights reserved.
//

import Foundation
import CoreData



class dataService {
    
    static let instance = dataService()
    
    private(set) var calendar = Calendar.current
    private(set) var offset = DateComponents()
    private(set) public var formatter = DateFormatter()
    private(set) public var daysInMonth: Int = 0
    private(set) public var currentDateIndex: Int = 0
    public var categories: [Category] = []

    //******************************************************************
    //MARK: Calendar related code
    //******************************************************************
    
    func arrayOfDates() -> [String] {
        let today = Date()
        let startDate = firstDayOfMonth()
        formatter.dateFormat = "MMM\ndd\nE"
        var dates: [String] = [formatter.string(from: startDate)]
        daysInMonth = numberOfDaysInMonth()
        for i in -30 ... 30 {
            offset.day = i+1
            let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
            let nextDayString = formatter.string(from: nextDay!)
            dates.append(nextDayString)
        }
        dates.remove(at: 0)
        print(currentDateIndex)
        currentDateIndex = find(value: formatter.string(from: today), in: dates)!
        return dates
    }
    
    func firstDayOfMonth() -> Date {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        return Calendar.current.date(from: comp)!
    }
    
    func daysBetweenStartAndEnd(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func numberOfDaysInMonth() -> Int {
        let interval = calendar.dateInterval(of: .month, for: Date())
        return calendar.dateComponents([.day], from: interval!.start, to: interval!.end).day!
    }
    
    
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }
        return nil
    }
    

    
    
    //******************************************************************
    //MARK: Categories related code (CoreData)
    //******************************************************************
    
        func fetchCategories(completion: (_ complete: Bool) -> ()) {
            guard let managedContext = appDelegate?.persistentContainer.viewContext
                else {
                    return
                }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            let sort = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            do {
                categories = try managedContext.fetch(fetchRequest) as! [Category]
                print("Fetched from CoreData Successfully")

            }
            catch
                {
                print("Could not fetch data: \(error.localizedDescription)")
            }
            }

        func fetchCoreDataObjects() {
            self.fetchCategories { (complete) in
                if categories.count == 0 {
                    print("NO CATEGORIES FOUND!")
                } else {
                    print("CATEGORIES FOUND")
                }
            }
        }
    
    //******************************************************************
    //MARK: Available new categories only to select from
    //******************************************************************
    
    
    private let newCategories = [
    Categories(title: "Alcohol", imageName: "alcohol.png"),
    Categories(title: "Apps", imageName: "apps.png"),
    Categories(title: "Bad Habits", imageName: "badHabit.png"),
    Categories(title: "Bars", imageName: "bars.png"),
    Categories(title: "Education", imageName: "education.png"),
    Categories(title: "Entertainment", imageName: "entertainment.png"),
    Categories(title: "Fast Food", imageName: "fastFood.png"),
    Categories(title: "Gas", imageName: "gas.png"),
    Categories(title: "Kids", imageName: "kids.png"),
    Categories(title: "Music", imageName: "music.png"),
    Categories(title: "Parking", imageName: "parking.png"),
    Categories(title: "Pets", imageName: "pets.png"),
    Categories(title: "Rent", imageName: "rent.png"),
    Categories(title: "Restaurants", imageName: "restaurant.png"),
    Categories(title: "Water", imageName: "waterCooler.png")
    ]
    
    func getNewCategories() -> [Categories] {
        return newCategories
    }
    
}
