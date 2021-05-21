//
//  HistoryViewController.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/3/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    
    let dateFormater = DateFormatter()
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
        
        // clean the cell
        cell.tableLabel.text = ""
        // get the data from the array and set the label
        let cellDailyData = items![indexPath.row]
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
            let dataToRemove = self.items![indexPath.row]
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
