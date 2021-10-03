//
//  LoginViewController.swift
//  Prepmewell
//
//  Created by ari on 7/30/21.
//

import UIKit
import SwiftyUserDefaults
import NVActivityIndicatorView

protocol LoginDisplayLogic {
    func displayAlert(response: TokenResponse)
    func displayError(alert: String)
}


class LoginViewController: UIViewController, UITextFieldDelegate, LoginDisplayLogic, NVActivityIndicatorViewable {
    
    func displayAlert(response: TokenResponse) {
        Defaults[\.token] = response.accessToken
        Defaults[\.isLoggedIn] = true
        
        self.stopAnimating()

        if response.accessToken != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: ScreenID.MAIN)
            sceneDelegate?.window?.rootViewController = controller
        }
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    
    var interactor : LoginBusinessLogic?
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    var countryCodes : String?
    var getNumber : String?
    
    let size = CGSize(width: 80, height: 80)
    
    
    func setupDependencies() {
        let presenter = LoginPresenter()
        presenter.loginView = self
        let networkClient = SignupApiClient()
        let loginWorker = LoginWorker()
        loginWorker.networkClient = networkClient
        let interactor = LoginInteractor()
        interactor.loginWorker = loginWorker
        interactor.presenter = presenter
        self.interactor = interactor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        hideKeyboard()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setUpTMemberText()
        passwordTextField.enablePasswordToggle()
        setupDependencies()
    }
    
    func navigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func didPressLoginUpBtn() {
        let username = emailTextField.text
        let password = passwordTextField.text
        if (username?.isEmpty == false && password?.isEmpty == false ){
            let data = LoginModel(userName: username ?? String(), password: password ?? String())
            interactor?.login(data: data)
            startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        }else if (username?.isEmpty == true && password?.isEmpty == false ) ||
                    (username?.isEmpty == false && password?.isEmpty == true ) {
            handleIncompleteDetails()
        } else {
            handleEmptyInputFields()
        }
    }
    
    func setUpTMemberText() {
        let strNumber: NSString = "Don't have an account? Sign up" as NSString
        let rangeOne = (strNumber).range(of: "Don't have an account?")
        let rangeTwo = (strNumber).range(of: "Sign up")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray.cgColor, range: rangeOne)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.44, green: 0.35, blue: 1, alpha: 1), range: rangeTwo)
        signUpLabel.attributedText = attribute
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapFunction))
        signUpLabel.addGestureRecognizer(tap)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        performSegue(withIdentifier: "loginToRegister", sender: nil)
    }
}
