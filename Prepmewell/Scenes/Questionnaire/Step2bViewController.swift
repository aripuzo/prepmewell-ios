//
//  Step2bViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import UIKit
import BEMCheckBox

protocol Step2bDisplayLogic {
    func displayCountries(countries: ListResponse<Country>)
    func displayCareerPaths(careerPaths: ListResponse<CareerPath>)
    func displayError(alert: String)
}

class Step2bViewController: UIViewController, Step2bDisplayLogic, BEMCheckBoxDelegate {
    func displayCountries(countries: ListResponse<Country>) {
        countryOptions.removeAll()
        countryOptions.append(contentsOf: countries.response)
        countryTextField.loadDropdownData(data: countryOptions, onSelect: country_onSelect)
    }
    
    func displayCareerPaths(careerPaths: ListResponse<CareerPath>) {
        careerPathOptions.removeAll()
        careerPathOptions.append(contentsOf: careerPaths.response)
        specializeTextField.loadDropdownData(data: careerPathOptions, onSelect: careerPath_onSelect)
    }
    
    func displayError(alert: String) {
        
    }
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var specializeTextField: UITextField!
    @IBOutlet weak var jobYesCheckbox: BEMCheckBox!
    @IBOutlet weak var jobNoCheckbox: BEMCheckBox!
    @IBOutlet weak var expJuniorCheckbox: BEMCheckBox!
    @IBOutlet weak var expMidCheckbox: BEMCheckBox!
    @IBOutlet weak var expSeniorCheckbox: BEMCheckBox!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    
    var interactor: QuestionnaireInteractor!
    var interestUpdate: InterestUpdate!
    var careerPathOptions:[CareerPath] = []
    var countryOptions:[Country] = []
    
    var jobCheckBoxes: [BEMCheckBox]?
    var expCheckBoxes: [BEMCheckBox]?
    
    func setUpDependencies() {
        (interactor.presenter as! QuestionnairePresenter).step2bView = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDependencies()
        
        interactor.getCountries()
        interactor.getCareerPaths()
        
        jobNoCheckbox.boxType = .square
        jobYesCheckbox.boxType = .square
        expJuniorCheckbox.boxType = .square
        expMidCheckbox.boxType = .square
        expSeniorCheckbox.boxType = .square
        
        jobCheckBoxes = [jobNoCheckbox, jobYesCheckbox]
        
        expCheckBoxes = [expJuniorCheckbox, expMidCheckbox, expSeniorCheckbox]
        
        expJuniorCheckbox.delegate = self
        expMidCheckbox.delegate = self
        expSeniorCheckbox.delegate = self
        
        jobNoCheckbox.delegate = self
        jobYesCheckbox.delegate = self
        
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
    
    func country_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.intendingToWork = selectedText
    }
    
    func careerPath_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.careerPath = selectedText
    }
    
    @objc func didPressNextBtn(sender:UITapGestureRecognizer) {
        if expJuniorCheckbox.on {
            interestUpdate.yearsOfExperience = 0
        }
        else if expMidCheckbox.on {
            interestUpdate.yearsOfExperience = 2
        }
        else if expSeniorCheckbox.on {
            interestUpdate.yearsOfExperience = 4
        }
        
        if jobYesCheckbox.on {
            interestUpdate.isGottenAJob = "yes"
        }
        else if jobNoCheckbox.on {
            interestUpdate.isGottenAJob = "no"
        }
        
        if interestUpdate.isGottenAJob?.isEmpty == true {
            handleIncorrectLoginDetails("Select job availability")
        }
        else if interestUpdate.yearsOfExperience == nil {
            handleIncorrectLoginDetails("Select experience level")
        }
        else {
            performSegue(withIdentifier: "step2bToStep3", sender: nil)
        }
    }
    
    @objc func didPressCancelBtn(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        let currentTag = checkBox.tag
        if checkBox == expMidCheckbox || checkBox == expSeniorCheckbox || checkBox == expJuniorCheckbox {
            guard let expCheckBoxes = expCheckBoxes else { return }
            for box in expCheckBoxes where box.tag != currentTag {
              box.on = false
            }
        }
        if checkBox == jobYesCheckbox || checkBox == jobNoCheckbox {
            guard let jobCheckBoxes = jobCheckBoxes else { return }
            for box in jobCheckBoxes where box.tag != currentTag {
              box.on = false
            }
        }
    }

}
