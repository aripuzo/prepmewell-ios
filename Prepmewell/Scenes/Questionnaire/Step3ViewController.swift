//
//  Step3ViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 24/03/2022.
//

import UIKit

protocol Step3DisplayLogic {
    func displayDegreeQualifications(degreeQualifications: ListResponse<DegreeQualification>)
    func displayError(alert: String)
}

class Step3ViewController: UIViewController, Step3DisplayLogic {
    func displayError(alert: String) {
        
    }
    
    func displayDegreeQualifications(degreeQualifications: ListResponse<DegreeQualification>) {
        degreeQualificationOptions.removeAll()
        degreeQualificationOptions.append(contentsOf: degreeQualifications.response)
        educationTextField.loadDropdownData(data: degreeQualificationOptions, onSelect: degreeQualification_onSelect)
    }
    
    var interactor: QuestionnaireInteractor!
    var interestUpdate: InterestUpdate!
    var degreeQualificationOptions:[DegreeQualification] = []
    
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var institutionTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    
    func setUpDependencies() {
        (interactor.presenter as! QuestionnairePresenter).step3View = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDependencies()
        
        interactor.getDegreeQualifications()
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressNextBtn))
        nextButton.addGestureRecognizer(nextTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressCancelBtn))
        cancelButton.addGestureRecognizer(cancelTap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myViewController = segue.destination as? Step4ViewController {
            myViewController.interactor = self.interactor as? QuestionnaireInteractor
            myViewController.interestUpdate = self.interestUpdate
        }
    }
    
    func degreeQualification_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.currentEducation = selectedText
    }
    
    @objc func didPressNextBtn(sender:UITapGestureRecognizer) {
        interestUpdate.currentInstitution = institutionTextField.text
        interestUpdate.currentProgramme = majorTextField.text
        interestUpdate.averageScore = scoreTextField.text
        
        if interestUpdate.currentInstitution == nil {
            handleIncorrectLoginDetails("Please enter institution")
        }
        else if interestUpdate.currentProgramme == nil {
            handleIncorrectLoginDetails("Please enter programme")
        }
        else if interestUpdate.averageScore == nil {
            handleIncorrectLoginDetails("Please enter average score")
        }
        else {
            performSegue(withIdentifier: "step3ToStep4", sender: nil)
        }
    }
    
    @objc func didPressCancelBtn(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

}
