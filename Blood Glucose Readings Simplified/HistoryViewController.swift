//
//  HistoryViewController.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/3/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    

    @IBOutlet weak var historyTableView: UITableView!
   
    var items:[DailyData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        fetchTheData()
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


}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.HISTORY_CELL, for: indexPath) as! CustomTableViewCell
        
        // get the data from the array and set the label
        let cellDailyData = items![indexPath.row]
        cell.tableLabel.text = """
            Date: \(cellDailyData.dateOfData!)
            Readings
            Fasting: \(cellDailyData.fastingData)
            1: \(cellDailyData.oneData)
            2: \(cellDailyData.twoData)
            3: \(cellDailyData.threeData)
            
            Carbs
            Breakfast: \(cellDailyData.breakfastData)
            Snack 1: \(cellDailyData.snackOneData)
            Lunch: \(cellDailyData.lunchData)
            Snack 2: \(cellDailyData.snackTwoData)
            Diner: \(cellDailyData.dinerData)
            """
        return cell
    }
}
