//
//  PasswordUpdateViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 11/02/2022.
//

import UIKit
import NVActivityIndicatorView

protocol ChangePasswordDisplayLogic {
    func displayUpdateResult(resut: String)
    func displayError(alert: String)
}

class PasswordUpdateViewController: UIViewController, ChangePasswordDisplayLogic, NVActivityIndicatorViewable {
    
    func displayUpdateResult(resut: String) {
        
    }
    
    func displayError(alert: String) {
        self.stopAnimating()
        handleNetworkError(prompt: alert)
    }
    
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    

    var interactor : ChangePasswordBusinessLogic?
    var preloader = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .systemBackground, padding: .none)
    
    let size = CGSize(width: 80, height: 80)
    
    func setupDependencies() {
        let presenter = ChangePasswordPresenter()
        presenter.homeView = self
        let networkClient = PrepmewellApiClient()
        let updateWorker = ChangePasswordWorker()
        updateWorker.networkClient = networkClient
        let interactor = ChangePasswordInteractor()
        interactor.worker = updateWorker
        interactor.presenter = presenter
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setupDependencies()
        
    }
    
    @IBAction func didPressUpdateBtn() {
        let oldPassword = oldPasswordTextField.text
        let newPassword = newPasswordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        if (oldPassword?.isEmpty == false && newPassword?.isEmpty == false && confirmPassword?.isEmpty == false && newPassword != confirmPassword){
            let data = ChangePassword(oldPassword: oldPassword!, newPassword: newPassword!, confirmPassword: confirmPassword!)
            interactor?.updatePassword(data: data)
            startAnimating(size, message: "Processing...", type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        } else {
            handleEmptyInputFields()
        }
    }

}
