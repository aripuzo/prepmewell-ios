//
//  ResetPasswordViewController.swift
//  Prepmewell
//
//  Created by ari on 7/30/21.
//

import UIKit
import SwiftyUserDefaults
import NVActivityIndicatorView

protocol ResetPasswordDisplayLogic {
    func displayResponse(response: StringResponse)
    func displayError(alert: String)
}

class ResetPasswordViewController: UIViewController, UITextFieldDelegate, ResetPasswordDisplayLogic, NVActivityIndicatorViewable {

    func displayResponse(response: StringResponse) {
        self.stopAnimating()
        if response.response != nil {
            handleSuccessfulMessage(message: response.response!, successCompletion: {})
        }
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginUpLabel: UILabel!
    
    var interactor : ResetPasswordBusinessLogic?
    var countryCodes : String?
    var getNumber : String?
    
    let size = CGSize(width: 80, height: 80)
    
    
    func setupDependencies() {
        let presenter = ResetPasswordPresenter()
        presenter.resetView = self
        let networkClient = SignupApiClient()
        let resetWorker = ResetPasswordWorker()
        resetWorker.networkClient = networkClient
        let interactor = ResetPasswordInteractor()
        interactor.resetPasswordWorker = resetWorker
        interactor.presenter = presenter
        self.interactor = interactor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationBar()
        hideKeyboard()
        emailTextField.delegate = self
        setUpTMemberText()
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
        if (email?.isEmpty == false){
            interactor?.resetPassword(email: email!)
            startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        }else if email?.isEmpty == true ||
                    email?.isEmpty == false {
            handleIncompleteDetails()
        } else {
            handleEmptyInputFields()
        }
    }
    
    func setUpTMemberText() {
        let strNumber: NSString = "Remember password? Login" as NSString
        let rangeOne = (strNumber).range(of: "Remember password?")
        let rangeTwo = (strNumber).range(of: "Login")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray.cgColor, range: rangeOne)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.44, green: 0.35, blue: 1, alpha: 1), range: rangeTwo)
        loginUpLabel.attributedText = attribute
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapFunction))
        loginUpLabel.addGestureRecognizer(tap)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        goBack()
    }

}
