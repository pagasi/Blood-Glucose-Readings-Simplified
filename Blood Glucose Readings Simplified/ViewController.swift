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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let arrayOfTextFields = [fastingTextField, oneTextField, twoTextField, threeTextField, breakfastTextField, snack1TextField, lunchTextField, snack2TextField, dinerTextField]
        
        arrayOfTextFields.forEach {$0!.placeholder = "###"}
        
    }
    
//    override func resignFirstResponder() -> Bool {
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
        self.view.endEditing(true)
    }
    @IBAction func historyPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SEGUE_VC_TO_HISTORYVC, sender: self)
    }
    @IBAction func submitPressed(_ sender: Any) {
        
        if fastingTextField.text != "" {
            print(fastingTextField.text!)
        }
        
        let fastingFloat = Float(fastingTextField.text!) ?? 0.0
        let oneFloat = Float(oneTextField.text!) ?? 0.0
        let twoFloat = Float(twoTextField.text!) ?? 0.0
        let threeFloat = Float(threeTextField.text!) ?? 0.0
        let breakfastFloat = Float(breakfastTextField.text!) ?? 0.0
        let snack1Float = Float(snack1TextField.text!) ?? 0.0
        let lunchFloat = Float(lunchTextField.text!) ?? 0.0
        let snack2Float = Float(snack2TextField.text!) ?? 0.0
        let dinerFloat = Float(dinerTextField.text!) ?? 0.0
        
        let arrayOfInputs = [fastingFloat, oneFloat, twoFloat, threeFloat, breakfastFloat, snack1Float, lunchFloat, snack2Float, dinerFloat]
        let currentDate = Date()
        
        print(arrayOfInputs)
        print(currentDate)
        
        saveDataToCore(dataToSave: arrayOfInputs, dateToSave: currentDate)
        
        performSegue(withIdentifier: Constants.SEGUE_VC_TO_HISTORYVC, sender: self)
    }
    
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
