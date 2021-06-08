//
//  HistoryViewController.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/3/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    let coreWorkForHVC = CoreWork()
    let rounder = RoundingConversion()
    let dateFormater = DateFormatter()
    var items:[DailyData] = []
    var last90DaysItems: [DailyData] = []
    let today = Date()
    
    
    @IBOutlet weak var rollingAvgLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        self.items = coreWorkForHVC.fetchTheData()
        
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
        
        calculateRolling()
        
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
//MARK: tableview extensions
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
                Dinner:         \(cellDailyData.dinerData)
            """
        return cell
    }
    
    //MARK: leading swipe "edit"
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //fetch data from core and arrange the floats into an array
        self.items = coreWorkForHVC.fetchTheData()
        
        let itemsFloatArray = [self.items[indexPath.row].fastingData, self.items[indexPath.row].oneData, self.items[indexPath.row].twoData, self.items[indexPath.row].threeData, self.items[indexPath.row].breakfastData, self.items[indexPath.row].snackOneData, self.items[indexPath.row].lunchData, self.items[indexPath.row].snackTwoData, self.items[indexPath.row].dinerData]
        
        let dateOfEntry = self.items[indexPath.row].dateOfData?.stringDateOnly()
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
//            pull up alert/child for editing
            let alert = UIAlertController(title: "Edit data for \(dateOfEntry ?? "")", message: "Hello Beautiful", preferredStyle: .alert)
            
            //add fields
            alert.addTextField { fastingField in
                if self.items[indexPath.row].fastingData == 0.0 {
                    fastingField.placeholder = "Fasting:" } else {
                        fastingField.placeholder = "Fasting:    \(String(self.items[indexPath.row].fastingData))"
                    }
                fastingField.keyboardType = .decimalPad
            }
            
            alert.addTextField { oneField in
                if self.items[indexPath.row].oneData == 0.0 {
                    oneField.placeholder = "1:" } else {
                        oneField.placeholder = "1:               \(String(self.items[indexPath.row].oneData))"
                    }
                oneField.keyboardType = .decimalPad
            }
            
            alert.addTextField { twoField in
                if self.items[indexPath.row].twoData == 0.0 {
                    twoField.placeholder = "2:" } else {
                        twoField.placeholder = "2:               \(String(self.items[indexPath.row].twoData))"
                    }
                twoField.keyboardType = .decimalPad
            }
            
            alert.addTextField { threeField in
                if self.items[indexPath.row].threeData == 0.0 {
                    threeField.placeholder = "3:" } else {
                        threeField.placeholder = "3:               \(String(self.items[indexPath.row].threeData))"
                    }
                threeField.keyboardType = .decimalPad
            }
            
            alert.addTextField { breakfastField in
                if self.items[indexPath.row].breakfastData == 0.0 {
                    breakfastField.placeholder = "Breakfast:" } else {
                        breakfastField.placeholder = "Breakfast: \(String(self.items[indexPath.row].breakfastData))"
                    }
                breakfastField.keyboardType = .decimalPad
            }
            
            alert.addTextField { snack1Field in
                if self.items[indexPath.row].snackOneData == 0.0 {
                    snack1Field.placeholder = "Snack 1:" } else {
                        snack1Field.placeholder = "Snack 1:     \(String(self.items[indexPath.row].snackOneData))"
                    }
                snack1Field.keyboardType = .decimalPad
            }
            
            alert.addTextField { lunchField in
                if self.items[indexPath.row].lunchData == 0.0 {
                    lunchField.placeholder = "Lunch:" } else {
                        lunchField.placeholder = "Lunch:        \(String(self.items[indexPath.row].lunchData))"
                    }
                lunchField.keyboardType = .decimalPad
            }
            alert.addTextField { snack2Field in
                if self.items[indexPath.row].snackTwoData == 0.0 {
                    snack2Field.placeholder = "Snack 2:" } else {
                        snack2Field.placeholder = "Snack 2:     \(String(self.items[indexPath.row].snackTwoData))"
                    }
                snack2Field.keyboardType = .decimalPad
            }
            
            alert.addTextField { dinerField in
                if self.items[indexPath.row].dinerData == 0.0 {
                    dinerField.placeholder = "Dinner:" } else {
                        dinerField.placeholder = "Dinner:        \(String(self.items[indexPath.row].dinerData))"
                    }
                dinerField.keyboardType = .decimalPad
            }
            
            //add submit buttons
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
                //capture fields
                guard let alertFields = alert.textFields else {return}
                
                let fastingAlertField = Float(alertFields[0].text ?? "0.0")
                let oneAlertField = Float(alertFields[1].text ?? "0.0")
                let twoAlertField = Float(alertFields[2].text ?? "0.0")
                let threeAlertField = Float(alertFields[3].text ?? "0.0")
                let breakfastAlertField = Float(alertFields[4].text ?? "0.0")
                let snack1AlertField = Float(alertFields[5].text ?? "0.0")
                let lunchAlertField = Float(alertFields[6].text ?? "0.0")
                let snack2AlertField = Float(alertFields[7].text ?? "0.0")
                let dinerAlertField = Float(alertFields[8].text ?? "0.0")
                
                let alertFieldsTexts = [fastingAlertField, oneAlertField, twoAlertField, threeAlertField, breakfastAlertField, snack1AlertField, lunchAlertField, snack2AlertField, dinerAlertField]
                
                var alertArrayToSave:[Float] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                for index in 0...8 {
                    if alertFieldsTexts[index] != nil {
                        alertArrayToSave[index] = alertFieldsTexts[index]!
                    } else {
                        alertArrayToSave[index] = itemsFloatArray[index]
                    }
                }
//                //update entry
                self.items[indexPath.row].fastingData = alertArrayToSave[0]
                self.items[indexPath.row].oneData = alertArrayToSave[1]
                self.items[indexPath.row].twoData = alertArrayToSave[2]
                self.items[indexPath.row].threeData = alertArrayToSave[3]
                self.items[indexPath.row].breakfastData = alertArrayToSave[4]
                self.items[indexPath.row].snackOneData = alertArrayToSave[5]
                self.items[indexPath.row].lunchData = alertArrayToSave[6]
                self.items[indexPath.row].snackTwoData = alertArrayToSave[7]
                self.items[indexPath.row].dinerData = alertArrayToSave[8]
//                //save new entry
                do {
                try Constants.CONTEXT.save()
                } catch {print("could not update the data")}
    //            refresh tableview
                DispatchQueue.main.async {
                    self.historyTableView.reloadData()
                    self.calculateRolling()
                }
            }))
            
            self.present(alert, animated: true)
        }
        //customize the leading swipe image&background
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = Constants.yaleBlueRGB
        
        //apply the actions to the tableview
        let swipe:UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        
        return swipe
    }
    //MARK:  trailing swipe "trash"
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
            self.items = self.coreWorkForHVC.fetchTheData()
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
                self.calculateRolling()
            }
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
