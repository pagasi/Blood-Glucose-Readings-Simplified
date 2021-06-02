//
//  CoreWork.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/29/21.
//

import Foundation

class CoreWork {
    //MARK: saveDataToCore
    func saveDataToCore(dataToSave data: [Float], dateToSave date: Date) {
        //create a new DailyData object
        let newSave = DailyData(context: Constants.CONTEXT)
        newSave.dateOfData = date
        newSave.fastingData = data[0]
        newSave.oneData = data[1]
        newSave.twoData = data[2]
        newSave.threeData = data[3]
        newSave.breakfastData = data[4]
        newSave.snackOneData = data[5]
        newSave.lunchData = data[6]
        newSave.snackTwoData = data[7]
        newSave.dinerData = data[8]
        //save the data
        do {
            try Constants.CONTEXT.save()
        } catch {
            print("Could not save the data")
        }
    }
    
    
    
}
