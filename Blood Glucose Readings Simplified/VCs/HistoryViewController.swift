//
//  HistoryViewController.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/3/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    let rounder = RoundingConversion()
    let dateFormater = DateFormatter()
    var items:[DailyData] = []
    var last90DaysItems: [DailyData] = []
    let today = Date()
    
    @IBOutlet weak var rollingAvgLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        fetchTheData()
        calculateRolling()
        
    }
    
    func fetchTheData() {
        //        fetch the data from core data to display in the tableview
        do {
            self.items = try Constants.CONTEXT.fetch(DailyData.fetchRequest())
            
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
            
        } catch  {
            print("Error fetching data")
        }
        
    }
    //MARK: calculate rolling avg
    func calculateRolling() {
        
        var last90DaysReadings:[Float] = []
        
        //remove all but 90 days
        //check that there is any data to work with
        if self.items != [] {
            //iterate through the data in the items array to check if its within 90 days
            for eachDay in self.items {
                let interval = DateInterval(start: eachDay.dateOfData!, end: self.today)
                //if less than 90 days duration, add to last90DaysItems array
                let lessThan90DaysCheck = interval.duration <= 7776000
                if lessThan90DaysCheck == true {
                    self.last90DaysItems.append(eachDay)
                }
            } // end loop through items array to check 90 days
        }
        last90DaysItems = self.items
        if last90DaysItems != [] {
            //fill last90DaysReadings with all the readings in the last90DaysItems array
            for eachDay in last90DaysItems {
                last90DaysReadings.append(eachDay.fastingData)
                last90DaysReadings.append(eachDay.oneData)
                last90DaysReadings.append(eachDay.twoData)
                last90DaysReadings.append(eachDay.threeData)
            }
            // clean out any readings that are 0.0
            last90DaysReadings.removeAll { $0 == 0.0 }
            
            //calculate the average readings in the last 90 days
            let calculatedTotal = last90DaysReadings.reduce(0.0, +)
            let calculatedAverage = calculatedTotal / Float(last90DaysReadings.count)
            let a1cEstimate:Float = (calculatedAverage + 46.7)/28.7
            let roundedEst = rounder.floatConversion(floatToConvert: a1cEstimate)
            let roundedCalculatedAvg = rounder.floatConversion(floatToConvert: calculatedAverage)
            //print to UI
            rollingAvgLabel.text = "Three month rolling average: \(roundedCalculatedAvg) \n Estimated A1C: \(roundedEst)"
        } else {
            rollingAvgLabel.text = "Please submit data"
        }
    } // end calculateRolling()
    
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.HISTORY_CELL, for: indexPath) as! CustomTableViewCell
        
        // MARK: clean the cell
        cell.tableLabel.text = ""
        // get the data from the array and set the label
        let cellDailyData = items[indexPath.row]
        dateFormater.dateStyle = .full
        cell.tableLabel.text = """
            \(dateFormater.string(from: cellDailyData.dateOfData!))
            
            READINGS
                Fasting:    \(cellDailyData.fastingData)
                1:               \(cellDailyData.oneData)
                2:               \(cellDailyData.twoData)
                3:               \(cellDailyData.threeData)
            
            CARBS
                Breakfast:  \(cellDailyData.breakfastData)
                Snack 1:     \(cellDailyData.snackOneData)
                Lunch:        \(cellDailyData.lunchData)
                Snack 2:     \(cellDailyData.snackTwoData)
                Diner:          \(cellDailyData.dinerData)
            """
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            //delete from core and tableview and refresh and animate
            //delete from context
            let dataToRemove = self.items[indexPath.row]
            Constants.CONTEXT.delete(dataToRemove)
            
            //save the context to core data
            do {
                try Constants.CONTEXT.save()
            } catch {
                print("Could not save the data")
            }
            
            //refresh the table
            self.fetchTheData()
            
            //            completionHandler(true)
        }
        //set delete action properties
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = Constants.crimsonRGB
        
        //apply the actions to the tableview
        let swipe:UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipe
    }
}
