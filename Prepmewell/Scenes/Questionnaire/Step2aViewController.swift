//
//  Step2aViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 19/03/2022.
//

import UIKit

protocol Step2aDisplayLogic {
    func displayStudies(studies: ListResponse<Study>)
    func displayStudyTimes(studyTimes: ListResponse<StudyTime>)
    func displayCountries(countries: ListResponse<Country>)
    func displayError(alert: String)
}

class Step2aViewController: UIViewController, Step2aDisplayLogic {
    
    func displayStudies(studies: ListResponse<Study>) {
        studyOptions.removeAll()
        studyOptions.append(contentsOf: studies.response)
        studyTextField.loadDropdownData(data: studyOptions, onSelect: study_onSelect)
    }
    
    func displayCountries(countries: ListResponse<Country>) {
        countryOptions.removeAll()
        countryOptions.append(contentsOf: countries.response)
        countryTextField.loadDropdownData(data: countryOptions, onSelect: country_onSelect)
    }
    
    func displayStudyTimes(studyTimes: ListResponse<StudyTime>) {
        studyTimeOptions.removeAll()
        studyTimeOptions.append(contentsOf: studyTimes.response)
        whenTextField.loadDropdownData(data: studyTimeOptions, onSelect: studyTime_onSelect)
    }
    
    func displayError(alert: String) {}
    
    @IBOutlet weak var studyTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var institutionTextField: UITextField!
    @IBOutlet weak var whenTextField: UITextField!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    
    var interactor: QuestionnaireInteractor!
    var interestUpdate: InterestUpdate!
    var studyOptions:[Study] = []
    var studyTimeOptions:[StudyTime] = []
    var countryOptions:[Country] = []
    
    func setUpDependencies() {
        (interactor.presenter as! QuestionnairePresenter).step2aView = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDependencies()
        
        interactor.getStudies()
        interactor.getCountries()
        interactor.getStudyTimes()
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressNextBtn))
        nextButton.addGestureRecognizer(nextTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(Step2aViewController.didPressCancelBtn))
        cancelButton.addGestureRecognizer(cancelTap)
    }
    
     
    func study_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.subject = selectedText
    }
    
    func studyTime_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.studyExpectingYear = selectedText
    }
    
    func country_onSelect(selectedText: String, selectedPosition: Int) {
        interestUpdate.studyDestination = selectedText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myViewController = segue.destination as? Step3ViewController {
            myViewController.interactor = self.interactor
            myViewController.interestUpdate = self.interestUpdate
        }
    }
    
    @objc func didPressNextBtn(sender:UITapGestureRecognizer) {
        interestUpdate.currentInstitution = institutionTextField.text
        if interestUpdate.subject == nil {
            handleIncorrectLoginDetails("Please enter subject")
        }
        else if interestUpdate.studyDestination == nil {
            handleIncorrectLoginDetails("Please enter destination")
        }
        else {
            performSegue(withIdentifier: "step2aToStep3", sender: nil)
        }
    }
    
    @objc func didPressCancelBtn(sender:UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

}
