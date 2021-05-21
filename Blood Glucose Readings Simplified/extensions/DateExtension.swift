//
//  DateExtension.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/19/21.
//

import Foundation

extension Date {
    
    func stringDateOnly() -> String {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        return formater.string(from: self)
    }
}
