//
//  Constants.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 4/29/21.
//

import Foundation
import UIKit

struct Constants {
    
    /* cells */
    
    static var HISTORY_CELL = "historyCell"
    
    /* reference the managed object context */
    
    static let CONTEXT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /* Colors */
    
    static var yaleBlueRGB = UIColor.init(red: 6/255, green: 71/255, blue: 137/255, alpha: 1)
    static var yaleBlueHex = "064789"
    static var greenSheenRGB = UIColor.init(red: 117/255, green: 187/255, blue: 167/255, alpha: 1)
    static var greenSheenHex = "75bba7"
    static var steelBlueHex = "427aa1"
    static var steelBlueRGB = UIColor.init(red: 66/255, green: 122/255, blue: 161/255, alpha: 1)
    static var crimsonHex = "941c2f"
    static var crimsonRGB = UIColor.init(red: 148/255, green: 28/255, blue: 47/255, alpha: 1)
    static var sandyBrownHex = "fc9f5b"
    static var sandyBrownRGB = UIColor.init(red: 252/255, green: 159/255, blue: 91/255, alpha: 1)
    
    //[{"name":"Yale Blue","hex":"064789","rgb":[6,71,137],"cmyk":[96,48,0,46],"hsb":[210,96,54],"hsl":[210,92,28],"lab":[30,9,-42]},
    
    //{"name":"Green Sheen","hex":"75bba7","rgb":[117,187,167],"cmyk":[37,0,11,27],"hsb":[163,37,73],"hsl":[163,34,60],"lab":[71,-27,3]},
    
    //{"name":"Steel Blue","hex":"427aa1","rgb":[66,122,161],"cmyk":[59,24,0,37],"hsb":[205,59,63],"hsl":[205,42,45],"lab":[49,-6,-26]},
    
    //    {"name":"Crimson UA","hex":"941c2f","rgb":[148,28,47],"cmyk":[0,81,68,42],"hsb":[351,81,58],"hsl":[351,68,35],"lab":[33,49,21]},
    
    //    {"name":"Sandy Brown","hex":"fc9f5b","rgb":[252,159,91],"cmyk":[0,37,64,1],"hsb":[25,64,99],"hsl":[25,96,67],"lab":[74,29,49]}]
}
