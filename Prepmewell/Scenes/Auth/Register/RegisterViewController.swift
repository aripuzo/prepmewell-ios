//
//  RegisterViewController.swift
//  Prepmewell
//
//  Created by ari on 7/30/21.
//

import UIKit
import SwiftyUserDefaults
import NVActivityIndicatorView

protocol RegisterDisplayLogic {
    func displayResponse(response: DataResponse<RegisterResponse>)
    func displayError(alert: String)
}

class RegisterViewController: UIViewController, UITextFieldDelegate, RegisterDisplayLogic, NVActivityIndicatorViewable {

    func displayResponse(response: DataResponse<RegisterResponse>) {
        self.stopAnimating()
        handleSuccessfulMessage(message: "Registration successful, please log in", successCompletion: { self.goBack() })
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    
    var interactor : RegisterBusinessLogic?
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    var countryCodes : String?
    var getNumber : String?
    
    let size = CGSize(width: 80, height: 80)
    
    
    func setupDependencies() {
        let presenter = RegisterPresenter()
        presenter.registerView = self
        let networkClient = SignupApiClient()
        let registerWorker = RegisterWorker()
        registerWorker.networkClient = networkClient
        let interactor = RegisterInteractor()
        interactor.registerWorker = registerWorker
        interactor.presenter = presenter
        self.interactor = interactor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        hideKeyboard()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        setUpTMemberText()
        passwordTextField.enablePasswordToggle()
        confirmPasswordTextField.enablePasswordToggle()
        setupDependencies()
    }
    
    func navigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func didPressLoginUpBtn() {
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        if (email?.isEmpty == false && password?.isEmpty == false && confirmPassword?.isEmpty == false){
            if confirmPassword != password {
                handleIncompatablePassword()
            }
            else {
                let data = RegisterModel(email: email ?? String(), password: password ?? String())
                interactor?.register(data: data)
                startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
            }
        }else if (email?.isEmpty == true || password?.isEmpty == true || confirmPassword?.isEmpty == true ) {
            handleIncompleteDetails()
        }
        else {
            handleEmptyInputFields()
        }
    }
    
    func setUpTMemberText() {
        let strNumber: NSString = "Already have an account? Log in" as NSString
        let rangeOne = (strNumber).range(of: "Already have an account?")
        let rangeTwo = (strNumber).range(of: "Log in")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray.cgColor, range: rangeOne)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.44, green: 0.35, blue: 1, alpha: 1), range: rangeTwo)
        signUpLabel.attributedText = attribute
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapFunction))
        signUpLabel.addGestureRecognizer(tap)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("pressed")
        goBack()
    }
}
