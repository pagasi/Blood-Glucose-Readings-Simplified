//
//  ViewController.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 4/29/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var fastingTextField: UITextField!
    @IBOutlet weak var oneTextField: UITextField!
    @IBOutlet weak var twoTextField: UITextField!
    @IBOutlet weak var threeTextField: UITextField!
    @IBOutlet weak var breakfastTextField: UITextField!
    @IBOutlet weak var snack1TextField: UITextField!
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var snack2TextField: UITextField!
    @IBOutlet weak var dinerTextField: UITextField!
    
    let defaults = UserDefaults.standard
    var arrayOfInputs:[Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var arrayOfTextFields: [UITextField?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runDelegates()

        self.arrayOfTextFields = [fastingTextField, oneTextField, twoTextField, threeTextField, breakfastTextField, snack1TextField, lunchTextField, snack2TextField, dinerTextField]
        
        arrayOfTextFields.forEach {$0!.placeholder = "###"}
        fillTextFields(arrayOfTextFields)
        backgroundChanges()
    }
    
    func runDelegates() {
        // setup delegates to self
        fastingTextField.delegate = self
        oneTextField.delegate = self
        twoTextField.delegate = self
        threeTextField.delegate = self
        breakfastTextField.delegate = self
        snack1TextField.delegate = self
        lunchTextField.delegate = self
        snack2TextField.delegate = self
        dinerTextField.delegate = self
    }
    //MARK: fill text fields func
    func fillTextFields(_ fieldsToFill:[UITextField?]) {
        let dateInDefault = defaults.object(forKey: "dateDefault") as? Date
        let currentDateForFill = Date()
        if dateInDefault?.stringDateOnly() == currentDateForFill.stringDateOnly() {
            let reloadedFastingTxt = defaults.float(forKey: "fastingFloatDefault")
            let reloaded1Txt = defaults.float(forKey: "oneFloatDefault")
            let reloaded2Txt = defaults.float(forKey: "twoFloatDefault")
            let reloaded3Txt = defaults.float(forKey: "threeFloatDefault")
            let reloadedBreakfastTxt = defaults.float(forKey: "breakfastFloatDefault")
            let reloadedSnack1Txt = defaults.float(forKey: "snack1FloatDefault")
            let reloadedLunchTxt = defaults.float(forKey: "lunchFloatDefault")
            let reloadedSnack2Txt = defaults.float(forKey: "snack2FloatDefault")
            let reloadedDinerTxt = defaults.float(forKey: "dinerFloatDefault")
            
            let arrayOfReloads = [reloadedFastingTxt, reloaded1Txt, reloaded2Txt, reloaded3Txt, reloadedBreakfastTxt, reloadedSnack1Txt, reloadedLunchTxt, reloadedSnack2Txt, reloadedDinerTxt]
            
            for index in 0...8 {
                self.arrayOfInputs[index] = arrayOfReloads[index]
                if arrayOfReloads[index] != 0.0 {
                    fieldsToFill[index]!.text = String(arrayOfReloads[index])
                }
            }
        } else {

            
            
//            MARK:  TODO: set alert to save yesterday's data to history
        }
    }
    

    
    //MARK: backgroundChanges
    func backgroundChanges() {
        
        if arrayOfInputs[0] > 120.0 {
            arrayOfTextFields[0]!.backgroundColor = Constants.crimsonRGB
        } else {
            fastingTextField.backgroundColor = Constants.greenSheenRGB
        } // end of background check for 0 (fasting)
        
        for index in 1...3 {
        if arrayOfInputs[index] > 150.0 {
            arrayOfTextFields[index]!.backgroundColor = Constants.crimsonRGB
        } else {
            arrayOfTextFields[index]!.backgroundColor = Constants.greenSheenRGB
        }
        } // end of loop background check for 1-3 (blood glucose check 1,2,3)
        
        let arrayOf30GramCaps = [arrayOfInputs[4], arrayOfInputs[6], arrayOfInputs[8]]
        let arrayOf30GramTextFields = [arrayOfTextFields[4], arrayOfTextFields[6], arrayOfTextFields[8]]
        for index in 0...2 {
            if arrayOf30GramCaps[index] > 30.0 {
                arrayOf30GramTextFields[index]!.backgroundColor = Constants.crimsonRGB
            } else {
                arrayOf30GramTextFields[index]!.backgroundColor = Constants.greenSheenRGB
            }
            
        } // end of loop background check for 4,6,8 (breakfast, lunch, and diner)
        
        if arrayOfInputs[5] > 15 {
            arrayOfTextFields[5]!.backgroundColor = Constants.crimsonRGB
        } else {
            arrayOfTextFields[5]!.backgroundColor = Constants.greenSheenRGB
        }
        
        if arrayOfInputs[7] > 15 {
            arrayOfTextFields[7]!.backgroundColor = Constants.crimsonRGB
        } else {
            arrayOfTextFields[7]!.backgroundColor = Constants.greenSheenRGB
        }
        
    } // end of background changes func
    
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //resign all text fields
        self.view.endEditing(true)
        
        //userdefaults save
        defaults.set(Date(), forKey: "dateDefault")
        defaults.set(Float(fastingTextField.text!) ?? 0.0, forKey: "fastingFloatDefault")
        defaults.set(Float(oneTextField.text!) ?? 0.0, forKey: "oneFloatDefault")
        defaults.set(Float(twoTextField.text!) ?? 0.0, forKey: "twoFloatDefault")
        defaults.set(Float(threeTextField.text!) ?? 0.0, forKey: "threeFloatDefault")
        defaults.set(Float(breakfastTextField.text!) ?? 0.0, forKey: "breakfastFloatDefault")
        defaults.set(Float(snack1TextField.text!) ?? 0.0, forKey: "snack1FloatDefault")
        defaults.set(Float(lunchTextField.text!) ?? 0.0, forKey: "lunchFloatDefault")
        defaults.set(Float(snack2TextField.text!) ?? 0.0, forKey: "snack2FloatDefault")
        defaults.set(Float(dinerTextField.text!) ?? 0.0, forKey: "dinerFloatDefault")
        
        let fastingFloat = Float(fastingTextField.text!) ?? 0.0
        let oneFloat = Float(oneTextField.text!) ?? 0.0
        let twoFloat = Float(twoTextField.text!) ?? 0.0
        let threeFloat = Float(threeTextField.text!) ?? 0.0
        let breakfastFloat = Float(breakfastTextField.text!) ?? 0.0
        let snack1Float = Float(snack1TextField.text!) ?? 0.0
        let lunchFloat = Float(lunchTextField.text!) ?? 0.0
        let snack2Float = Float(snack2TextField.text!) ?? 0.0
        let dinerFloat = Float(dinerTextField.text!) ?? 0.0
        
        self.arrayOfInputs = [fastingFloat, oneFloat, twoFloat, threeFloat, breakfastFloat, snack1Float, lunchFloat, snack2Float, dinerFloat]
        backgroundChanges()
    }
    //MARK: historyPressed
    @IBAction func historyPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SEGUE_VC_TO_HISTORYVC, sender: self)
    }
    
    
    //MARK: submitPressed
    @IBAction func submitPressed(_ sender: Any) {
        
        if fastingTextField.text != "" {
            print(fastingTextField.text!)
        }
        let currentDate = Date()
            
        print(arrayOfInputs)
        print(currentDate)
        
        saveDataToCore(dataToSave: arrayOfInputs, dateToSave: currentDate)
        
        performSegue(withIdentifier: Constants.SEGUE_VC_TO_HISTORYVC, sender: self)
    }
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



extension ViewController: UITextFieldDelegate {
    
    
    
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        textField.backgroundColor = Constants.yaleBlueRGB
    //        return true
    //    }
}
