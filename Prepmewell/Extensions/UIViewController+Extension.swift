//
//  UIViewController+Extension.swift
//  Prepmewell
//
//  Created by ari on 7/31/21.
//

import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return nil }
         return delegate
    }
    
    func handleEmptyInputFields(){
        let alertController = UIAlertController(title: "Empty Input Fields", message: "Email and Password Field are Empty", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func handleIncompleteDetails(){
        let alertController = UIAlertController(title: "Empty Input Fields", message: "Email or Password Field is Empty", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Try again?", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func handleInvalidEmail() {
        let alertController = UIAlertController(title: "incorrect email", message: "Please re-enter your email", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func handleEmptyEmailTextField() {
        let alert = UIAlertController(title: "⚠️", message: "Email Field is Empty", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleIncompleteOTP() {
        let alert = UIAlertController(title: "⚠️", message: "Incomplete OTP", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleIncompatablePassword() {
        let alert = UIAlertController(title: "⚠️", message: "Passwords do not match", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleNetworkError(prompt: String) {
        //let holdPrompt = String(prompt.dropFirst(33))
        let holdPrompt = prompt
        let alert = UIAlertController(title: "⚠️", message: holdPrompt, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleIncorrectLoginDetails(_ message: String) {
        let alert = UIAlertController(title: "⚠️", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleSuccessfulMessage(message: String, successCompletion: @escaping () -> ()) {
        let alert = UIAlertController(title: "✅", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: successCompletion)
    }
    
    func handleUserNotVerified(_ verfMessage: String) {
        let verifyScreen = ViewController()
        let alert = UIAlertController(title: "⚠️", message: verfMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            self.navigationController?.pushViewController(verifyScreen, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleErrorMessage(message: String) {
        let alert = UIAlertController(title: "⚠️", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
            
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
            
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
            
        return self
    }
    
    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}
