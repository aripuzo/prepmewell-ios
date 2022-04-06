//
//  ProfileUpdateViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import UIKit
import SwiftyUserDefaults
import NVActivityIndicatorView
import BEMCheckBox

protocol ProfileUpdateDisplayLogic {
    func displayUpdateResult(resut: DataResponse<User>)
    func displayCountries(countries: ListResponse<Country>)
    func displayError(alert: String)
}

class ProfileUpdateViewController: UIViewController, ProfileUpdateDisplayLogic, NVActivityIndicatorViewable, BEMCheckBoxDelegate {
    
    func displayUpdateResult(resut: DataResponse<User>) {
        self.stopAnimating()
    }
    
    func displayCountries(countries: ListResponse<Country>) {
        
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var maleCheckbox: BEMCheckBox!
    @IBOutlet weak var femaleCheckbox: BEMCheckBox!
    
    var genderCheckBoxes: [BEMCheckBox]?
    
    var interactor : ProfileUpdateBusinessLogic?
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    
    let size = CGSize(width: 80, height: 80)
    
    var recordNo = 0
    
    func setupDependencies() {
        let presenter = ProfileUpdatePresenter()
        presenter.homeView = self
        let networkClient = PrepmewellApiClient()
        let updateWorker = ProfileUpdateWorker()
        updateWorker.networkClient = networkClient
        let interactor = ProfileUpdateInteractor()
        interactor.worker = updateWorker
        interactor.presenter = presenter
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        //emailTextField.delegate = self
        setupDependencies()
        displayUser(user: Defaults[\.userData])
        
        usernameTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        
        genderCheckBoxes = [maleCheckbox, femaleCheckbox]
        
        maleCheckbox.delegate = self
        femaleCheckbox.delegate = self
        
    }
    
    func salutations_onSelect(selectedText: String) {
        if selectedText == "" {
            print("Hello World")
        } else if selectedText == "Mr." {
            print("Hello Sir")
        } else {
            print("Hello Madame")
        }
    }
    
    func displayUser(user: User?) {
        if let user = user {
            recordNo = user.id
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            emailTextField.text = user.email
            usernameTextField.text = user.userName
            dobTextField.text = user.dateOfBirth
            
            if user.gender == "male" {
                maleCheckbox.on = true
            } else {
                femaleCheckbox.on = true
            }
        }
    }
    
    @IBAction func didPressUpdateBtn() {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let email = emailTextField.text
        let username = usernameTextField.text
        let gender = maleCheckbox.isSelected ? "male" : "female"
        if (firstName?.isEmpty == false && lastName?.isEmpty == false){
            let data = UserUpdate(id: recordNo, lastName: lastName!, firstName: firstName!, dateOfBirth: "", gender: gender, email: email!, phoneNumber: "", userName: username!, location: "")
            interactor?.updateUser(data: data)
            startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        } else {
            handleEmptyInputFields()
        }
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
      // 1
      let currentTag = checkBox.tag
      // 2
      guard let genderCheckBoxes = genderCheckBoxes else { return }
      // 3
      for box in genderCheckBoxes where box.tag != currentTag {
        
        // 4
        box.on = false
      }
    }

}
