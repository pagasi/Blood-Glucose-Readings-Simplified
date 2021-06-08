//
//  ViewController.swift
//  Blood Glucose Readings Simplified
//
//  Created by Whitney Naquin on 4/29/21.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, PassTouchesScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var glucoseHeaderLabel: UILabel!
    @IBOutlet weak var carbsHeaderLabel: UILabel!
    
    @IBOutlet weak var scrollView: PassTouchesScrollView!
    @IBOutlet weak var fastingTextField: UITextField!
    @IBOutlet weak var oneTextField: UITextField!
    @IBOutlet weak var twoTextField: UITextField!
    @IBOutlet weak var threeTextField: UITextField!
    @IBOutlet weak var breakfastTextField: UITextField!
    @IBOutlet weak var snack1TextField: UITextField!
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var snack2TextField: UITextField!
    @IBOutlet weak var dinerTextField: UITextField!
    
    @IBOutlet weak var breakfastGraphView: UIView!
    @IBOutlet weak var snack1GraphView: UIView!
    @IBOutlet weak var lunchGraphView: UIView!
    @IBOutlet weak var snack2GraphView: UIView!
    @IBOutlet weak var dinnerGraphView: UIView!
    
    
    let defaults = UserDefaults.standard
    var arrayOfInputs:[Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var arrayOfTextFields: [UITextField?] = []
    var isExpand:Bool = false
    var activeTextField:UITextField? = nil
    let coreWorkForVC = CoreWork()
    let animateGraphForVC = AnimateGraph()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runDelegates()
        setupLabels()
        setupObservers()
        setupArrayAndPlaceholders()
        fillTextFields(arrayOfTextFields)
        backgroundChanges()
    }
    
    //MARK: delegates
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
        scrollView.delegate = self
        scrollView.delegatePass = self
    }
    
    //MARK: labels setup
    func setupLabels() {
//        glucoseHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        glucoseHeaderLabel.layer.cornerRadius = 10
//        glucoseHeaderLabel.layer.backgroundColor = Constants.sandyBrownRGB.cgColor
//        glucoseHeaderLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
//        glucoseHeaderLabel.layer.shadowColor = UIColor.black.cgColor
//        glucoseHeaderLabel.layer.shadowRadius = 5
//        glucoseHeaderLabel.layer.shadowOpacity = 1
        
//        carbsHeaderLabel.layer.cornerRadius = 20
//        carbsHeaderLabel.layer.backgroundColor = Constants.sandyBrownRGB.cgColor
//        carbsHeaderLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
//        carbsHeaderLabel.layer.shadowColor = UIColor.black.cgColor
//        carbsHeaderLabel.layer.shadowRadius = 5
//        carbsHeaderLabel.layer.shadowOpacity = 1
    }
    
    //MARK: observers setup
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardAppear() {
        if !isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
            
            if breakfastTextField.isFirstResponder == true || snack1TextField.isFirstResponder == true || lunchTextField.isFirstResponder == true || snack2TextField.isFirstResponder == true || dinerTextField.isFirstResponder == true {
//             print(activeTextField)
//                self.scrollView.scrollRectToVisible(dinerTextField.frame, animated: false)
                self.scrollView.setContentOffset(CGPoint(x: 0.0, y: dinerTextField.frame.origin.y + 100), animated: true)
            }
            
            self.isExpand = true
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpand == true {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
        self.isExpand = false
        }
    }
    
    //MARK: array and placeholders
    func setupArrayAndPlaceholders() {
        self.arrayOfTextFields = [fastingTextField, oneTextField, twoTextField, threeTextField, breakfastTextField, snack1TextField, lunchTextField, snack2TextField, dinerTextField]
        
        arrayOfTextFields.forEach {$0!.placeholder = "###"}
    }
    
    
    //MARK: check date, fill textFields
    func fillTextFields(_ fieldsToFill:[UITextField?]) {
        let dateInDefault = defaults.object(forKey: "dateDefault") as? Date
        let currentDateForFill = Date()
        if dateInDefault == nil {
            defaults.set(Date(), forKey: "dateDefault")
            return}
        if dateInDefault?.stringDateOnly() == currentDateForFill.stringDateOnly() {
            let arrayOfReloads = reloadDataFromDefault()
            for index in 0...8 {
                self.arrayOfInputs[index] = arrayOfReloads[index]
                if arrayOfReloads[index] != 0.0 {
                    fieldsToFill[index]!.text = String(arrayOfReloads[index])
                }
            }
        } else {
//            MARK:  Save yesterday's data to history
            let arrayOfReloads = reloadDataFromDefault()
            coreWorkForVC.saveDataToCore(dataToSave: arrayOfReloads, dateToSave: dateInDefault!)
            //refresh dateDefault
            defaults.set(Date(), forKey: "dateDefault")
        }
    }
    
    func reloadDataFromDefault() -> [Float] {
        let reloadedFastingTxt = defaults.float(forKey: "fastingFloatDefault")
        let reloaded1Txt = defaults.float(forKey: "oneFloatDefault")
        let reloaded2Txt = defaults.float(forKey: "twoFloatDefault")
        let reloaded3Txt = defaults.float(forKey: "threeFloatDefault")
        let reloadedBreakfastTxt = defaults.float(forKey: "breakfastFloatDefault")
        let reloadedSnack1Txt = defaults.float(forKey: "snack1FloatDefault")
        let reloadedLunchTxt = defaults.float(forKey: "lunchFloatDefault")
        let reloadedSnack2Txt = defaults.float(forKey: "snack2FloatDefault")
        let reloadedDinerTxt = defaults.float(forKey: "dinerFloatDefault")
        
        let arrayOfReloadsForReloadFromDefaultFunc = [reloadedFastingTxt, reloaded1Txt, reloaded2Txt, reloaded3Txt, reloadedBreakfastTxt, reloadedSnack1Txt, reloadedLunchTxt, reloadedSnack2Txt, reloadedDinerTxt]
        
        return arrayOfReloadsForReloadFromDefaultFunc
    }
    
    //MARK: backgroundChanges red/green
    func backgroundChanges() {
        
        if arrayOfInputs[0] > 130.0 {
            arrayOfTextFields[0]!.backgroundColor = Constants.crimsonRGB
        } else {
            fastingTextField.backgroundColor = Constants.greenSheenRGB
        } // end of background check for 0 (fasting)
        
        for index in 1...3 {
        if arrayOfInputs[index] > 180.0 {
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
    
    func touchBegan() {
        //resign all text fields
        self.view.endEditing(true)

        //userdefaults save
//        defaults.set(Date(), forKey: "dateDefault")
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
        animateGraphForVC.drawPaths(onView: breakfastGraphView)
        print("touched!")
    }
    
    func touchMoved() {
        print("touch moved")
    }

    //MARK: historyPressed
    @IBAction func historyPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SEGUE_VC_TO_HISTORYVC, sender: self)
    }
    
    
    //MARK: submitPressed
    @IBAction func submitPressed(_ sender: Any) {

        let currentDate = Date()
            
        coreWorkForVC.saveDataToCore(dataToSave: arrayOfInputs, dateToSave: currentDate)
        
        performSegue(withIdentifier: Constants.SEGUE_VC_TO_HISTORYVC, sender: self)
    }

}


