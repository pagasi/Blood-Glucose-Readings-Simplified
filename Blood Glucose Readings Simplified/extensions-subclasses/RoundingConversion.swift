//
//  RoundingConversion.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 5/27/21.
//

import Foundation
import UIKit

class RoundingConversion {

    func floatConversion (floatToConvert:Float) -> Float {
        
        let movedDecimalToRight = (floatToConvert * 10)
        let roundedWhileDecimalMoved = movedDecimalToRight.rounded()
        let theAnswer = roundedWhileDecimalMoved/10
        
        return theAnswer
    }
}
