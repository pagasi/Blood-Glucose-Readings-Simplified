//
//  DailyData+CoreDataProperties.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/11/21.
//
//

import Foundation
import CoreData


extension DailyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyData> {
        return NSFetchRequest<DailyData>(entityName: "DailyData")
    }

    @NSManaged public var dateOfData: Date?
    @NSManaged public var fastingData: Float
    @NSManaged public var oneData: Float
    @NSManaged public var twoData: Float
    @NSManaged public var threeData: Float
    @NSManaged public var breakfastData: Float
    @NSManaged public var snackOneData: Float
    @NSManaged public var snackTwoData: Float
    @NSManaged public var lunchData: Float
    @NSManaged public var dinerData: Float

}

extension DailyData : Identifiable {

}
