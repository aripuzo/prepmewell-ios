//
//  Step2cViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import UIKit
import BEMCheckBox

protocol Step2cDisplayLogic {
    func displayRelocateLocations(relocateLocations: ListResponse<RelocateLocation>)
    func displayError(alert: String)
}

class Step2cViewController: UIViewController, Step2cDisplayLogic, BEMCheckBoxDelegate {
    
    func displayRelocateLocations(relocateLocations: ListResponse<RelocateLocation>) {
        relocateLocationOptions.removeAll()
        relocateLocationOptions.append(contentsOf: relocateLocations.response)
        relocateTextField.loadDropdownData(data: relocateLocationOptions, onSelect: relocateLocation_onSelect)
    }
    
    func displayError(alert: String) {
        
    }
    
    @IBOutlet weak var relocateTextField: UITextField!
    @IBOutlet weak var eligibleYesCheckbox: BEMCheckBox!
    @IBOutlet weak var eligibleNoCheckbox: BEMCheckBox!
    @IBOutlet weak var eligibleNotSureCheckbox: BEMCheckBox!
    @IBOutlet weak var consultationYesCheckbox: BEMCheckBox!
    @IBOutlet weak var consultationNoCheckbox: BEMCheckBox!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    
    var interactor: QuestionnaireInteractor!
    var interestUpdate: InterestUpdate!
    var relocateLocationOptions:[RelocateLocation] = []
    
    var eligibleCheckBoxes: [BEMCheckBox]?
    var consultationCheckBoxes: [BEMCheckBox]?
    
    func setUpDependencies() {
        (interactor.presenter as! QuestionnairePresenter).step2cView = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDependencies()
        
        interactor.getRelocateLocations()
        
        eligibleYesCheckbox.boxType = .square
        eligibleNoCheckbox.boxType = .square
        eligibleNotSureCheckbox.boxType = .square
        consultationYesCheckbox.boxType = .square
        consultationNoCheckbox.boxType = .square
        
        eligibleCheckBoxes = [eligibleYesCheckbox, eligibleNoCheckbox, eligibleNotSureCheckbox]
        
        consultationCheckBoxes = [consultationYesCheckbox, consultationNoCheckbox]
        
        eligibleNoCheckbox.delegate = self
        eligibleYesCheckbox.delegate = self
        eligibleNotSureCheckbox.delegate = self
        
        consultationNoCheckbox.delegate = self
        consultationYesCheckbox.delegate = self
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressNextBtn))
        nextButton.addGestureRecognizer(nextTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressCancelBtn))
        cancelButton.addGestureRecognizer(cancelTap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myViewController = segue.destination as? Step3ViewController {
            myViewController.interactor = self.interactor
            myViewController.interestUpdate = self.interestUpdate
        }
    }
    
    func relocateLocation_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.relocation = selectedText
    }
    
    @objc func didPressNextBtn(sender:UITapGestureRecognizer) {
        if eligibleNoCheckbox.on {
            interestUpdate.isEligibleForRelocation = "no"
        }
        else if eligibleYesCheckbox.on {
            interestUpdate.isEligibleForRelocation = "yes"
        }
        else if eligibleNotSureCheckbox.on {
            interestUpdate.isEligibleForRelocation = "not sure"
        }
        
        if consultationYesCheckbox.on {
            interestUpdate.isNeedConsultation = "yes"
        }
        else if consultationNoCheckbox.on {
            interestUpdate.isNeedConsultation = "no"
        }
        
        if interestUpdate.isEligibleForRelocation?.isEmpty == true {
            handleIncorrectLoginDetails("Select eligibility")
        }
        else if interestUpdate.isNeedConsultation == nil {
            handleIncorrectLoginDetails("Select need for consultation")
        }
        else {
            performSegue(withIdentifier: "step2cToStep3", sender: nil)
        }
    }
    
    @objc func didPressCancelBtn(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        let currentTag = checkBox.tag
        if checkBox == eligibleNoCheckbox || checkBox == eligibleYesCheckbox || checkBox == eligibleNotSureCheckbox {
            guard let eligibleCheckBoxes = eligibleCheckBoxes else { return }
            for box in eligibleCheckBoxes where box.tag != currentTag {
              box.on = false
            }
        }
        if checkBox == consultationYesCheckbox || checkBox == consultationNoCheckbox {
            guard let consultationCheckBoxes = consultationCheckBoxes else { return }
            for box in consultationCheckBoxes where box.tag != currentTag {
              box.on = false
            }
        }
    }

}
