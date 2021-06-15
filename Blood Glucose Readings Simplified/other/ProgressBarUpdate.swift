//
//  ProgressBarUpdate.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 6/8/21.
//

import Foundation
import UIKit

class ProgressBarUpdate {
    
    func update(bar: UIProgressView, withFloat newFloat: Float, withCap cap: Float) {
        
        
        let calculatedProgress:Float = { () -> Float in
            var total:Float = 0
            let calc = newFloat/cap
            if calc >= 1 {
                total = 1.0
            } else {
                total = calc
            }
            return total
        }()
        
        bar.setProgress(calculatedProgress, animated: true)
    }
}
